//
//  ClientSearchViewController.swift
//  AnywhereFitness
//
//  Created by Alex Rhodes on 9/22/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit
import CoreData

class ClientSearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var classDetailStackView: UIStackView!
    @IBOutlet weak var viewLayover: UIView!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var classController = ClassController()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        classDetailStackView.isHidden = true
        viewLayover.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setViews() {
        
        if let classObject = classController.classObject {
            classDetailStackView.isHidden = false
            viewLayover.isHidden = false
            for object in classObject {
            classNameLabel.text = object.name
            durationLabel.text = object.duration
            intensityLabel.text = object.intensityLevel
            categoryLabel.text = object.category
            dateLabel.text = "\(object.date ?? Date())"
            locationLabel.text = object.location
            }
            
        }
        
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ClientSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetch.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetch.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainerCell", for: indexPath)
        
        let classObject = fetch.object(at: indexPath)
        
        cell.textLabel?.text = classObject.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        guard let cellObjectInfo = fetch.sections?[section] else { return nil }
        
        return cellObjectInfo.name.capitalized
    }
}

extension ClientSearchViewController: NSFetchedResultsControllerDelegate {
    
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

extension ClientSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        
        let context  = CoreDataStack.shared.mainContext
        
        context.performAndWait {
            classController.preformSearch(with: searchTerm) { (error) in
                self.setViews()
            }
        }
    }
}
