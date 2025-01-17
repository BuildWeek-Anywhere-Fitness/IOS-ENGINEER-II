//
//  TrainerViewController.swift
//  AnywhereFitness
//
//  Created by Alex Rhodes on 9/22/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit
import CoreData

class TrainerViewController: UIViewController {
    
    let classController = ClassController.shared
    
    var userController = UserController.shared
    
    var classType = ClassType.trainerClasses
    
   lazy var fetch: NSFetchedResultsController<Class> = {
        
        let request: NSFetchRequest<Class> = Class.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        // basically sorts everything
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createAClassButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setViews() {
        createAClassButton.backgroundColor = #colorLiteral(red: 0.1839953661, green: 0.7992369533, blue: 0.443231672, alpha: 1)
        createAClassButton.setTitle("CREATE CLASS", for: .normal)
        createAClassButton.setTitleColor(.white, for: .normal)
        createAClassButton.layer.cornerRadius = 6
    }
    
    // METHODS:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TrainerCreateClassModalSegue" {
            guard let destination = segue.destination as? TrainerCreateClassViewController else {return}
            destination.classController = classController
            destination.userController = userController
        } else  if segue.identifier == "TrainerClassDetailModalSegue" {
            guard let destination = segue.destination as? TrainerCreateClassViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            destination.classObject = fetch.object(at: indexPath)
        }
    }
}

extension TrainerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetch.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetch.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerCell", for: indexPath) as? TrainerHomeTableViewCell else {return UITableViewCell()}
        
        cell.classObject = fetch.object(at: indexPath)
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let cellObjectInfo = fetch.sections?[section] else { return nil }
        
        return cellObjectInfo.name.capitalized
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let classObject = fetch.object(at: indexPath)
            classController.deleteClass(classObject: classObject)
        }
    }
}

extension TrainerViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
        let sectionsSet = IndexSet(integer: sectionIndex)
        
        switch type {
        case .insert:
            tableView.insertSections(sectionsSet, with: .automatic)
        case .delete:
            tableView.deleteSections(sectionsSet, with: .automatic)
        default:
            return
        }
    }
}
