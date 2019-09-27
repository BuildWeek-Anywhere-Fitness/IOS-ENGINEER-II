//
//  TableViewCell.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/24/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addClassButton: UIButton!
    
    var classController = ClassController.shared
    var classType: ClassType?
    
    
    var classObject: Class? {
        didSet {
            setViews()
        }
    }
    
    var isAdded = false
    
    private func setViews() {
        
        
        
        guard let classObject = classObject else {return}
        
        classNameLabel.text = classObject.name
        durationLabel.text = classObject.duration
        intensityLabel.text = classObject.intensityLevel
        categoryLabel.text = classObject.category
        
        if isAdded == false {
            addClassButton.setBackgroundImage(#imageLiteral(resourceName: "empty"), for: .normal)
        } else if isAdded == true {
            addClassButton.setBackgroundImage(#imageLiteral(resourceName: "green"), for: .normal)
        } else if classObject.classType == ClassType.clientClasses.rawValue {
            addClassButton.setBackgroundImage(#imageLiteral(resourceName: "green"), for: .normal)
        }
        
    }
    @IBAction func addClassButtonTapped(_ sender: UIButton) {
        guard let classObject = classObject else {return}
        
        if isAdded == false {
            classController.updateClassType(with: classObject, classType: ClassType.clientClasses)
            isAdded = true
            setViews()
        } else {
            classController.updateClassType(with: classObject)
            isAdded = false
            setViews()
        }
    }
    
}
