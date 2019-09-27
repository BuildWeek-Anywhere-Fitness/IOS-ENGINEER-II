//
//  ClientHomeTableViewCell.swift
//  AnywhereFitnessUnit2Build
//
//  Created by Alex Rhodes on 9/26/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

class ClientHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
   
    var classController: ClassController?
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
    }
}
