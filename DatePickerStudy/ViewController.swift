//
//  ViewController.swift
//  DatePickerStudy
//
//  Created by Phoenix Wu on H30/04/26.
//  Copyright © 平成30年 Phoenix Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DatePickerTableViewCellDelegate, TextFieldTableViewCellDelegate {
    
    // cell identifiers
    let textFieldCellIdentifier = "TextFieldViewCell"
    
    let datePickerCellIdentifier = "DatePickerTableViewCell"
    
    // outlets
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var personImgView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // data
    let person = Person(userId: "aw8v9w7fh3978vh",
                        password: "AllYourP4ssw0rdsAr3BelongToU5",
                        name: "Anne White",
                        email: "annewhite123@example.com",
                        startedWorkDate: Person.dateFromString(dateString: "04/01/1995"),
                        endedWorkDate: Person.dateFromString(dateString: "06/15/2001"),
                        phoneNumber: "+1(202)123-4567",
                        image: UIImage(named: "anneWhite"),
                        maritalStatus: "single",
                        address: "123rd Fake Street N, Tacoma, WA 98765, US")
    
    let fields: [ModelFieldType] = [.name, .email, .startedWorkDate, .endedWorkDate, .phoneNumber, .maritalStatus, .address]
    
    let dateFields: [ModelFieldType] = [.startedWorkDate, .endedWorkDate]
    
    // datepicker related data
    var datePickerIndexPath: IndexPath?
    
    var datePickerVisible: Bool { return datePickerIndexPath != nil }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: select row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // add 1 if date picker is visible
        return datePickerVisible ? fields.count + 1 : fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datePickerVisible, let datePickerIdx = datePickerIndexPath, datePickerIdx == indexPath {
            // specify cell
            let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier) as! DatePickerTableViewCell
            
            // set delegate
            cell.delegate = self
            
            let field = fields[indexPath.row - 1]
            cell.configureWithField(field: field, currentDate: person.valueForField(field: field) as? Date)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: textFieldCellIdentifier) as! TextFieldViewCell
            cell.delegate = self
            
            let field = calculateFieldForIndexPath(indexPath: indexPath)
            cell.configureWithField(field: field, andValue: person.valueForField(field: field) as? String, editable: !dateFields.contains(field))
            
            return cell
        }
    }
    
    func calculateFieldForIndexPath(indexPath: IndexPath) -> ModelFieldType {
        // TODO: calculateFieldForIndexPath
        
        return fields[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // load cells to table view
        tableView.register(UINib(nibName: "TextFieldViewCell", bundle: nil), forCellReuseIdentifier: textFieldCellIdentifier)
        tableView.register(UINib(nibName: "DatePickerTableViewCell", bundle: nil), forCellReuseIdentifier: datePickerCellIdentifier)
        
        // row height
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func dateChangedForField(field: ModelFieldType, toDate date: Date) {
        // TODO: dateChangedForField
    }
    
    func fieldDidBeginEditing(field: ModelFieldType) {
        // TODO: fieldDidBeginEditing
    }
    
    func field(field: ModelFieldType, changedValueTo value: String) {
        // TODO: field
    }
    
}

