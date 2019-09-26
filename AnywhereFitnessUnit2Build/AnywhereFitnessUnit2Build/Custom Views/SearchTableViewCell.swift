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
    
    var classController: ClassController?
    
    var classObject: Class?
    
    var isAdded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setViews() {
        guard let classObject = classObject else {return}
        
        classNameLabel.text = classObject.name
        durationLabel.text = classObject.duration
        intensityLabel.text = classObject.intensityLevel
        categoryLabel.text = classObject.category
        
        if isAdded {
            addClassButton.setTitle("Add Class", for: .normal)
        } else {
            addClassButton.setTitle("RemoveClass", for: .normal)
        }
        
    }
    @IBAction func addClassButtonTapped(_ sender: UIButton) {
        guard let classObject = classObject else {return}
        
        if isAdded == false {
            classController?.updateClassType(with: classObject, classType: ClassType.clientClasses)
            isAdded = true
        } else {
            classController?.updateClassType(with: classObject)
            isAdded = false
        }
    }
    
}
