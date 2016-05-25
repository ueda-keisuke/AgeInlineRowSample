//
//  AgeRow.swift
//  slps2
//
//  Created by Neuro Leap on 2016/05/19.
//  Copyright © 2016年 Neuro Leap. All rights reserved.
//

import Eureka

public class AgePickerCell: Cell<Int>, CellType, UIPickerViewDataSource, UIPickerViewDelegate {
    
    public lazy var picker: UIPickerView = { [unowned self] in
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(picker)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": picker]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": picker]))
        return picker
        }()
    
    private var pickerRow: AgePickerRow? { return row as? AgePickerRow }
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override func setup() {
        super.setup()
        height = { UITableViewAutomaticDimension }
        accessoryType = .None
        editingAccessoryType = .None
        picker.delegate = self
        picker.dataSource = self
    }
    
    deinit {
        picker.delegate = nil
        picker.dataSource = nil
    }
    
    public override func update() {
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        picker.reloadAllComponents()
        if let selectedValue = pickerRow?.year_value, let index = pickerRow?.year_options.indexOf(selectedValue) {
            picker.selectRow(index, inComponent: 0, animated: true)
        }
        
        if let selectedValue = pickerRow?.month_value, let index = pickerRow?.month_options.indexOf(selectedValue) {
            picker.selectRow(index, inComponent: 1, animated: true)
        }
        
    }
    
    public func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch(component) {
        case 0:
            return 40
        case 1:
            return 100
        case 2:
            return 40
        case 3:
            return 100
        default:
            return 0
        }
    }
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch(component) {
        case 0:
            return pickerRow?.year_options.count ?? 0
        case 1:
            return 1
        case 2:
            return pickerRow?.month_options.count ?? 0
        case 3:
            return 1
        default:
            break
        }
        
        return 0
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var value = ""
        
        switch(component) {
        case 0:
            if let year = pickerRow?.year_options[row] {
                value = String(year)
            }
            break
            
        case 1:
            value = "years"
            if let year = pickerRow?.year_value
            {
                if year == 0 || year == 1
                {
                    value = "year"
                }
            }
            
            break
            
        case 2:
            if let month = pickerRow?.month_options[row] {
                value = String(month)
            }
            
            break
            
        case 3:
            value = "months"
            if let month = pickerRow?.month_value
            {
                if month == 0 || month == 1
                {
                    value = "month"
                }
            }
            break
            
        default:
            break
        }
        
        return value
        
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            if let year = pickerRow?.year_options[row] {
                pickerRow?.year_value = year
                picker.reloadComponent(1)
            }
        }
        
        if component == 2
        {
            if let month = pickerRow?.month_options[row] {
                pickerRow?.month_value = month
                picker.reloadComponent(3)
            }
        }
        
        // call onChange
        if let row = pickerRow, let year = pickerRow?.year_value, let month = pickerRow?.month_value {
            row.value = (year + 1) * (month + 1)
        }
    }
}


public final class AgePickerRow: Row<Int, AgePickerCell>, RowType {
    
    public var year_options = [Int]()
    public var month_options = [Int]()
    
    var year_value: Int? = 0
    var month_value: Int? = 0
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class _AgeInlineRow: Row<Int, AgeInlineCell> {
    
    public typealias InlineRow = AgePickerRow
    public var year_options = [Int]()
    public var month_options = [Int]()
    public var noValueDisplayText: String?
    
    var year_value: Int?
    var month_value: Int?
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/*
 
 public final class AgeInlineRow: _AgeInlineRow, RowType, InlineRowType {
 
 required public init(tag: String?) {
 super.init(tag: tag)
 onExpandInlineRow { cell, row, _ in
 let color = cell.detailTextLabel?.textColor
 row.onCollapseInlineRow { cell, _, _ in
 cell.detailTextLabel?.textColor = color
 }
 cell.detailTextLabel?.textColor = cell.tintColor
 }
 }
 
 public override func customDidSelect() {
 super.customDidSelect()
 if !isDisabled {
 toggleInlineRow()
 }
 }
 
 public func setupInlineRow(inlineRow: InlineRow) {
 inlineRow.year_options = self.year_options
 inlineRow.month_options = self.month_options
 inlineRow.displayValueFor = self.displayValueFor
 }
 }
 
 */

public class AgeInlineCell: Cell<Int>, CellType {
    
    var year_value: Int?
    var month_value: Int?
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        height = { UITableViewAutomaticDimension }
    }
    
    public override func setup() {
        super.setup()
        selectionStyle = .None
        accessoryType = .None
        editingAccessoryType =  .None
    }
    
    public override func update() {
        super.update()
        selectionStyle = row.isDisabled ? .None : .Default
    }
    
    public override func didSelect() {
        super.didSelect()
        row.deselect()
    }
}
