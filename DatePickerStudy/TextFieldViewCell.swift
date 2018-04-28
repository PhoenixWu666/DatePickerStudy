//
//  TextFieldViewCell.swift
//  DatePickerStudy
//
//  Created by Phoenix Wu on H30/04/26.
//  Copyright © 平成30年 Phoenix Wu. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    
    func fieldDidBeginEditing(field: ModelFieldType)
    
    func field(field: ModelFieldType, changedValueTo value: String)
    
}

class TextFieldViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var fieldNameLabel: UILabel!
    
    @IBOutlet weak var fieldValueTextfield: UITextField!
    
    // data
    var field: ModelFieldType!
    
    weak var delegate: TextFieldTableViewCellDelegate?
    
    func configureWithField(field: ModelFieldType, andValue value: String?, editable: Bool) {
        self.field = field
        self.fieldNameLabel.text = self.field.rawValue
        self.fieldValueTextfield.text = value ?? ""
        
        /*
         判断追加
         date picker のフィールドは文字入力不要なので、isUserInteractionEnabled の値が false、選択できる。
         一方、文字入力できるフィールドは選択できない。
         */
        if editable {
            // 文字入力のフィールド
            self.fieldValueTextfield.isUserInteractionEnabled = true
            self.selectionStyle = .none
        } else {
            // date picker のフィールド
            self.fieldValueTextfield.isUserInteractionEnabled = false
            self.selectionStyle = .default
        }
    }
    
    // UITextFieldDelegate's function
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.fieldDidBeginEditing(field: field)
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        self.delegate?.field(field: field, changedValueTo: sender.text ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldValueTextfield.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
