//
//  ViewController.swift
//  AgeInlineRowSample
//
//  Created by keta on 2016/05/20.
//  Copyright © 2016年 Keisuke Ueda. All rights reserved.
//

import Eureka

public class AgePickerCell: Cell<Age>, CellType, UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        if let selectedValue = pickerRow?.value?.year, let index = pickerRow?.year_options.indexOf(selectedValue) {
            picker.selectRow(index, inComponent: 0, animated: true)
        }
        
        if let selectedValue = pickerRow?.value?.month, let index = pickerRow?.month_options.indexOf(selectedValue) {
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
            if let year = pickerRow?.value?.year
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
            if let month = pickerRow?.value?.month
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
        
        let value_of_this_class = self.row.value
        let value_of_pickerRow = pickerRow?.value
        
        if component == 0 {
            if let year = pickerRow?.year_options[row] {
                
                value_of_pickerRow?.year = year
                pickerRow?.value = value_of_pickerRow
                
                value_of_this_class?.year = year
                self.row.value = value_of_this_class
                
                picker.reloadComponent(1)
            }
        }
        
        if component == 2
        {
            if let month = pickerRow?.month_options[row] {
                
                value_of_pickerRow?.month = month
                pickerRow?.value = value_of_pickerRow
                
                value_of_this_class?.month = month
                self.row.value = value_of_this_class
                
                picker.reloadComponent(3)
            }
        }
    }
}


public final class AgePickerRow: Row<Age, AgePickerCell>, RowType {
    
    public var year_options = [Int]()
    public var month_options = [Int]()
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

public class AgeInlineCell: Cell<Age>, CellType {
    
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


public class _AgeInlineRow: Row<Age, AgeInlineCell> {
    
    public typealias InlineRow = AgePickerRow
    public var year_options = [Int]()
    public var month_options = [Int]()
    public var noValueDisplayText: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
        
        displayValueFor =  {
            guard let date = $0 else {
                return nil
            }
            
            let y = date.year
            let m = date.month
            
            return "\(y) year\(y >= 2 ? "s" : "") and \(m) month\(m >= 2 ? "s" : "") old."
        }
    }
}



public final class AgeInlineRow_<T>: _AgeInlineRow, RowType, InlineRowType {
    
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

public typealias AgeInlineRow = AgeInlineRow_<Age>

public class Age: Equatable
{
    var year:Int = 0
    var month:Int = 0
}

public func ==(lhs: Age, rhs: Age) -> Bool
{
    //    let result = (lhs.year == rhs.year) && (lhs.month == rhs.month)
    return false
}

