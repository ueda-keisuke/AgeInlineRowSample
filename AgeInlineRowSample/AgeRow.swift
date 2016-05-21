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

    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return pickerRow?.year_options.count ?? 0
        } else {
            return pickerRow?.month_options.count ?? 0
        }

    }

    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        var value = ""

        switch(component) {
        case 0:
            if let year = pickerRow?.year_options[row] {
                if year >= 2 {
                    value = "\(year) years"
                } else {
                    value = "\(year) year"
                }
            }
            break
        case 1:
            if let month = pickerRow?.month_options[row] {
                if month >= 2 {
                    value = "\(month) months"
                } else {
                    value = "\(month) month"
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
            }
        } else {
            if let month = pickerRow?.month_options[row] {
                pickerRow?.month_value = month
            }
        }
    }

}


public final class AgePickerRow: Row<Int, AgePickerCell>, RowType {

    public var year_options = [Int]()
    public var month_options = [Int]()

    var year_value: Int?
    var month_value: Int?

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

//public final class AgeInlineRow: _AgeInlineRow, RowType, InlineRowType {
//
//    required public init(tag: String?) {
//        super.init(tag: tag)
//        onExpandInlineRow { cell, row, _ in
//            let color = cell.detailTextLabel?.textColor
//            row.onCollapseInlineRow { cell, _, _ in
//                cell.detailTextLabel?.textColor = color
//            }
//            cell.detailTextLabel?.textColor = cell.tintColor
//        }
//    }
//
//    public override func customDidSelect() {
//        super.customDidSelect()
//        if !isDisabled {
//            toggleInlineRow()
//        }
//    }
//
//    public func setupInlineRow(inlineRow: InlineRow) {
//        inlineRow.year_options = self.year_options
//        inlineRow.month_options = self.month_options
//        inlineRow.displayValueFor = self.displayValueFor
//    }
//}

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



