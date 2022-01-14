//
//  CustomDatePickerController.swift
//  GlobalDents
//
//  Created by Qazi Naveed on 9/8/17.
//  Copyright © 2017 Qazi Naveed. All rights reserved.
//

import UIKit

class CustomDatePickerController: UIViewController {

    var selectedData:String! = ""
    var doneButtonTapped: ((String)->())?

    var sourceTxtFeild: UITextField!
    var format : String = ApplicationConstants.YearFormat
    @IBOutlet weak var datePickerObj: UIDatePicker!
    var mode:Int = 1
    var datePickerMode = 1

    static func createDatePickerController(storyboardId:String)->CustomDatePickerController {
        let datePicker = UIStoryboard(name: "SearchAndFindPicker", bundle: nil).instantiateViewController(withIdentifier: storyboardId) as! CustomDatePickerController
        return datePicker
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerObj.datePickerMode = UIDatePicker.Mode(rawValue: datePickerMode)!
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        close()
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        switch (mode){
            
        case 0:
            selectedData = Utility.getTimeInString(datePickerObj.date)
            break
            
        case 1:
            selectedData = Utility.getDateInString(datePickerObj.date, format: format)
            break
            
        default:
            break
        }
        
        doneButtonTapped?(selectedData)
        close()
    }
    
    @IBAction func pickerValueChanged(_ sender: Any) {
        selectedData = Utility.getDateInString(datePickerObj.date, format: format)
        
    }
    
    func show(controller:UIViewController) {
        controller.addChild(self)
        controller.view.addSubview(self.view)
    }
    
    func close() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
