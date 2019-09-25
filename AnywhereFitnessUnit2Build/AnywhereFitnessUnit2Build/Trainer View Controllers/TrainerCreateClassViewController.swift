//
//  TainerCreateClassViewController.swift
//  AnywhereFitness
//
//  Created by Alex Rhodes on 9/22/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

class TrainerCreateClassViewController: UIViewController {
    
    var classController: ClassController?
    
    var classObject: Class? {
        didSet {
            setViews()
        }
    }
    
    var category: Category?
    var intensity: Intensity?
    var duration: Duration?
    var selectedDate: Date?
    var categoryPicker: UIPickerView = UIPickerView()
    var categoryPickerData: [Category] = []
    var datePicker: UIDatePicker = UIDatePicker()
    var durationPicker: UIPickerView = UIPickerView()
    var durationPickerData:[Duration] = []
    var intensityPicker: UIPickerView = UIPickerView()
    var intensityPickerData: [Intensity] = []
    var secondsFromGMT: Int { return TimeZone.current.secondsFromGMT() }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        return formatter
    }
    
    
    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var intensityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()
    }
    
    private func setViews() {
        if let classObject = classObject {
            
            classNameTextField.text = classObject.name
            categoryTextField.text = classObject.category
            dateTextField.text = "\(String(describing: classObject.date))"
            durationTextField.text = classObject.duration
            intensityTextField.text = classObject.intensityLevel
            locationTextField.text = classObject.location
            
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        let date = datePicker.date
        
        let classType = ClassType.trainerClasses
        
        guard let name = classNameTextField.text,
            let category = Category(rawValue: categoryTextField.text!),
            let duration = Duration(rawValue: durationTextField.text!),
            let intesity = Intensity(rawValue: intensityTextField.text!),
            let location = locationTextField.text,
            !name.isEmpty, !location.isEmpty
            else {return}
        
        if let classObject = classObject {
            classController?.updateClass(with: classObject, name: name, location: location, intesityLevel: intesity, duration: duration, date: date, category: category)
        } else {
            classController?.createClass(with: name, location: location, intensityLevel: intesity, duration: duration, date: date, category: category, classType: classType)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension TrainerCreateClassViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // tag = key
    // 0 = category
    // 1 = duration
    // 2 = intensity
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 0 {
            return categoryPickerData.count
        } else if pickerView.tag == 1 {
            return durationPickerData.count
        } else if pickerView.tag == 2 {
            return intensityPickerData.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return categoryPickerData[row].rawValue
        } else if pickerView.tag == 1 {
            return durationPickerData[row].rawValue
        } else if pickerView.tag == 2 {
            return intensityPickerData[row].rawValue
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if pickerView.tag == 0 {
            let titleData = categoryPickerData[row]
            let myTitle = NSAttributedString(string: titleData.rawValue, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
            return myTitle
        } else if pickerView.tag == 1 {
            let titleData = durationPickerData[row]
            let myTitle = NSAttributedString(string: titleData.rawValue, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
            return myTitle
        } else if pickerView.tag == 2 {
            let titleData = intensityPickerData[row]
            let myTitle = NSAttributedString(string: titleData.rawValue, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
            return myTitle
        } else {
            let titleData = categoryPickerData[row]
            let myTitle = NSAttributedString(string: titleData.rawValue, attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 17.0)!,NSAttributedString.Key.foregroundColor:UIColor.black])
            return myTitle
        }
    }
}

extension TrainerCreateClassViewController {
    
    // MARK: Category Picker View Toolbar func
    @objc func categoryPickerViewDoneTapped() {
        category = categoryPickerData[categoryPicker.selectedRow(inComponent: 0)]
        if let category = category {
            categoryTextField.text = category.rawValue
        }
        categoryTextField.resignFirstResponder()
    }
    
    @objc func categoryPickerViewCancelTapped() {
        categoryTextField.resignFirstResponder()
    }
    
    // MARK: Intensity Picker View Toolbar func
    @objc func intensityPickerViewDoneTapped() {
        intensity = intensityPickerData[intensityPicker.selectedRow(inComponent: 0)]
        if let intensity = intensity {
            intensityTextField.text = intensity.rawValue
        }
        intensityTextField.resignFirstResponder()
    }
    
    @objc func intensityPickerViewCancelTapped() {
        intensityTextField.resignFirstResponder()
    }
    
    // MARK: Duration Picker View Toolbar func
    @objc func durationPickerViewDoneTapped() {
        duration = durationPickerData[durationPicker.selectedRow(inComponent: 0)]
        if let duration = duration {
            durationTextField.text = duration.rawValue
        }
        durationTextField.resignFirstResponder()
    }
    
    @objc func durationPickerViewCancelTapped() {
        durationTextField.resignFirstResponder()
    }
    
    // MARK: Date Picker View Toolbar func
    @objc func datePickerViewDoneTapped() {
        selectedDate = datePicker.date
        if let selectedDate = selectedDate {
            dateTextField.text = dateFormatter.string(from: selectedDate)
        }
        dateTextField.resignFirstResponder()
    }
    
    @objc func datePickerViewCancelTapped() {
        dateTextField.resignFirstResponder()
    }
    
    private func setupPickers() {
        // set delegates and data source
        categoryPicker.tag = 0
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        durationPicker.tag = 1
        durationPicker.delegate = self
        durationPicker.dataSource = self
        intensityPicker.tag = 2
        intensityPicker.delegate = self
        intensityPicker.dataSource = self
        
        // MARK: Configuring Date Picker view
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        datePicker.setValue(UIColor.black, forKey: "textColor")
        
        // Adding Date Picker toolbar
        let datePickerToolBar = UIToolbar()
        datePickerToolBar.barStyle = UIBarStyle.default
        datePickerToolBar.isTranslucent = true
        datePickerToolBar.tintColor = .black
        datePickerToolBar.barTintColor = .white
        datePickerToolBar.sizeToFit()
        
        let doneButtonDatePicker = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(datePickerViewDoneTapped))
        let spaceButtonDatePicker = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButtonDatePicker = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(datePickerViewCancelTapped))
        
        
        datePickerToolBar.setItems([cancelButtonDatePicker, spaceButtonDatePicker, doneButtonDatePicker], animated: false)
        datePickerToolBar.isUserInteractionEnabled = true
        
        // Additional Date Picker Setup
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = datePickerToolBar
        
        // MARK: Configuring Category Picker view
        categoryPicker.backgroundColor = .white
        
        // Adding Picker View toolbar
        let categoryPickerToolBar = UIToolbar()
        categoryPickerToolBar.barStyle = UIBarStyle.default
        categoryPickerToolBar.isTranslucent = true
        categoryPickerToolBar.tintColor = .black
        categoryPickerToolBar.barTintColor = .white
        categoryPickerToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(categoryPickerViewDoneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(categoryPickerViewCancelTapped))
        
        categoryPickerToolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        categoryPickerToolBar.isUserInteractionEnabled = true
        
        // Additional Picker View Setup
        categoryTextField.inputView = categoryPicker
        categoryTextField.inputAccessoryView = categoryPickerToolBar
        for category in Category.allCases {
            categoryPickerData.append(category)
        }
        
        // MARK: Configuring Intensity Picker view
        intensityPicker.backgroundColor = .white
        
        // Adding Picker View toolbar
        let intensityPickerToolBar = UIToolbar()
        intensityPickerToolBar.barStyle = UIBarStyle.default
        intensityPickerToolBar.isTranslucent = true
        intensityPickerToolBar.tintColor = .black
        intensityPickerToolBar.barTintColor = .white
        intensityPickerToolBar.sizeToFit()
        
        let intensityDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(intensityPickerViewDoneTapped))
        let intensitySpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let intensityCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(intensityPickerViewCancelTapped))
        
        intensityPickerToolBar.setItems([intensityCancelButton, intensitySpaceButton, intensityDoneButton], animated: false)
        intensityPickerToolBar.isUserInteractionEnabled = true
        
        // Additional Picker View Setup
        intensityTextField.inputView = intensityPicker
        intensityTextField.inputAccessoryView = intensityPickerToolBar
        for intensity in Intensity.allCases {
            intensityPickerData.append(intensity)
        }
        
        // MARK: Configuring Duration Picker view
        durationPicker.backgroundColor = .white
        
        // Adding Picker View toolbar
        let durationPickerToolBar = UIToolbar()
        durationPickerToolBar.barStyle = UIBarStyle.default
        durationPickerToolBar.isTranslucent = true
        durationPickerToolBar.tintColor = .black
        durationPickerToolBar.barTintColor = .white
        durationPickerToolBar.sizeToFit()
        
        let durationDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(durationPickerViewDoneTapped))
        let durationSpaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let durationCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(durationPickerViewCancelTapped))
        
        durationPickerToolBar.setItems([durationCancelButton, durationSpaceButton, durationDoneButton], animated: false)
        durationPickerToolBar.isUserInteractionEnabled = true
        
        // Additional Picker View Setup
        durationTextField.inputView = durationPicker
        durationTextField.inputAccessoryView = durationPickerToolBar
        for duration in Duration.allCases {
            durationPickerData.append(duration)
        }
    }
}
