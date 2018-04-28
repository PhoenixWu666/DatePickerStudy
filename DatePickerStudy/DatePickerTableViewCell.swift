//
//  DatePickerTableViewCell.swift
//  DatePickerStudy
//
//  Created by Phoenix Wu on H30/04/26.
//  Copyright © 平成30年 Phoenix Wu. All rights reserved.
//

import UIKit

protocol DatePickerTableViewCellDelegate: class {
    func dateChangedForField(field: ModelFieldType, toDate date: Date)
}

class DatePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // data
    var field: ModelFieldType!
    
    weak var delegate: DatePickerTableViewCellDelegate?
    
    func configureWithField(field: ModelFieldType, currentDate: Date?) {
        self.field = field
        self.datePicker.date = currentDate ?? Date()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        self.delegate?.dateChangedForField(field: field, toDate: datePicker.date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
