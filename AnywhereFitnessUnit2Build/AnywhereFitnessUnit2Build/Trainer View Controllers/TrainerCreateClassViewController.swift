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
    
    var categoryPicker: UIPickerView = UIPickerView()
    var datePicker: UIPickerView = UIPickerView()
    var durationPicker: UIPickerView = UIPickerView()
    var intensityPicker: UIPickerView = UIPickerView()
    

    @IBOutlet weak var classNameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var intensityTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        let date = Date()
        
        guard let name = classNameTextField.text,
            let caegory = categoryTextField?.text,
            let duration = durationTextField.text,
            let intesity = intensityTextField.text,
            let location = locationTextField.text else {return}
        
        classController?.createClass(with: name, location: location, intesityLevel: intesity, duration: duration, date: date, category: caegory)
        
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
}

extension TrainerCreateClassViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    
    
}
