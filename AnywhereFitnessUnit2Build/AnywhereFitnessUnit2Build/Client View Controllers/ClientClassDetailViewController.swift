//
//  ClientClassDetailViewController.swift
//  AnywhereFitness
//
//  Created by Alex Rhodes on 9/22/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit

class ClientClassDetailViewController: UIViewController {
    
    var classObject: Class? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
    }
    
    private func setViews() {
        guard let classObject = classObject else {return}
        
        classLabel.text = classObject.name
        durationLabel.text = classObject.duration
        intensityLabel.text = classObject.intensityLevel
        categoryLabel.text = classObject.category
        dateLabel.text = "\(classObject.date ?? Date())"
        locationLabel.text = classObject.location
    }
    
    @IBAction func dontButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
