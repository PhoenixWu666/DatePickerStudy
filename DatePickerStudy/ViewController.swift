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
                        image: UIImage(named: "sample"),
                        maritalStatus: "single",
                        address: "123rd Fake Street N, Tacoma, WA 98765, US")
    
    let fields: [ModelFieldType] = [.name, .email, .startedWorkDate, .endedWorkDate, .phoneNumber, .maritalStatus, .address]
    
    let dateFields: [ModelFieldType] = [.startedWorkDate, .endedWorkDate]
    
    // datepicker related data
    var datePickerIndexPath: IndexPath?
    
    var datePickerVisible: Bool { return datePickerIndexPath != nil }
    
    // DatePickerTableViewCellDelegate methods
    func dateChangedForField(field: ModelFieldType, toDate date: Date) {
        print("date changed for field \(field) to \(date)")
        person.setValue(value: date, forField: field)
        self.tableView.reloadData()
    }
    
    // TextFieldTableViewCellDelegate
    func fieldDidBeginEditing(field: ModelFieldType) {
        dismissDatePickerRow()
    }
    
    // TextFieldTableViewCellDelegate
    func field(field: ModelFieldType, changedValueTo value: String) {
        print("value changed for field \(field) to \(value)")
        person.setValue(value: value, forField: field)
        self.tableView.reloadData()
    }
    
    func datePickerIsRightBelowMe(indexPath: IndexPath) -> Bool {
        if datePickerVisible, datePickerIndexPath!.section == indexPath.section {
            return indexPath.row == datePickerIndexPath!.row - 1
        } else {
            return false
        }
    }
    
    func dismissDatePickerRow() {
        if datePickerVisible {
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
            datePickerIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func datePickerShouldAppearForRowSelection(at: IndexPath) -> Bool {
        return dateFields.contains(calculateFieldForIndexPath(indexPath: at))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !datePickerShouldAppearForRowSelection(at: indexPath) {
            // dismiss concurrent date picker row if user selected any non-date row
            dismissDatePickerRow()
        } else {
            self.view.endEditing(true)
            
            /*
             Note:
             iOS expects developer will manipulate table view between table view's beginUpdates() and endUpdates().
             If do nothing at there, app will crush.
             */
            // table view begin update
            tableView.beginUpdates()
            
            // MUST DO SOMETHING, unless remove invocation of table view's beginUpdates() and endUpdates()
            if datePickerVisible {
                // delete date picker row which is already on screen first
                tableView.deleteRows(at: [datePickerIndexPath!], with: .fade)
                
                let oldDatePickerIndexPath = datePickerIndexPath!
                
                if datePickerIsRightBelowMe(indexPath: indexPath) {
                    /*
                     selected row had displayed date picker right below itself, so just dismiss this date picker and
                     set datePickerIndexPath as nil
                     */
                    self.datePickerIndexPath = nil
                } else {
                    // insert new row
                    let newRow = oldDatePickerIndexPath.row < indexPath.row ? indexPath.row : indexPath.row + 1
                    self.datePickerIndexPath = IndexPath(row: newRow, section: indexPath.section)
                    tableView.insertRows(at: [self.datePickerIndexPath!], with: .fade)
                }
            } else {
                // there is no date pickers in table view, just insert a row for date picker
                self.datePickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                tableView.insertRows(at: [self.datePickerIndexPath!], with: .fade)
            }
            
            // table view end update
            tableView.endUpdates()
        }
    }
    
    func calculateFieldForIndexPath(indexPath: IndexPath) -> ModelFieldType {
        if datePickerVisible, let datePickerIndexPath = self.datePickerIndexPath, datePickerIndexPath.section == indexPath.section {
            if datePickerIndexPath.row > indexPath.row {
                return fields[indexPath.row]
            } else {
                return fields[indexPath.row - 1]
            }
        } else {
            return fields[indexPath.row]
        }
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
            cell.configureWithField(field: field, andValue: person.stringValueForField(field: field), editable: !dateFields.contains(field))
            
            return cell
        }
    }
    
}

