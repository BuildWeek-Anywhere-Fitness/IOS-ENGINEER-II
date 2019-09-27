//
//  ClientViewController.swift
//  AnywhereFitness
//
//  Created by Alex Rhodes on 9/22/19.
//  Copyright © 2019 Alex Rhodes. All rights reserved.
//

import UIKit
import CoreData

class ClientViewController: UIViewController {
    
    @IBOutlet weak var searchForAClassButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var classController = ClassController.shared
    var userController = UserController.shared
    
    var classType: ClassType = ClassType.clientClasses
    
    var isLogin = true
    
    lazy var fetch: NSFetchedResultsController<Class> = {
        
        let request: NSFetchRequest<Class> = Class.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        request.predicate = NSPredicate(format: "classType == %@", classType.rawValue)
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
        tableView.dataSource = self
        setViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    private func setViews() {
        searchForAClassButton.backgroundColor = #colorLiteral(red: 0.1839953661, green: 0.7992369533, blue: 0.443231672, alpha: 1)
        searchForAClassButton.setTitle("SEARCH CLASSES", for: .normal)
        searchForAClassButton.setTitleColor(.white, for: .normal)
        searchForAClassButton.layer.cornerRadius = 6
        
    }
    
    @IBAction func searchForAClassButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ClientSearchModalSearch", sender: sender)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ClientClassDetailModalSegue" {
            guard let destination = segue.destination as? ClientClassDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            destination.classObject = fetch.object(at: indexPath)
        } else if segue.identifier == "ClientSearchModalSearch" {
            guard let destination = segue.destination as? ClientSearchViewController else {return}
            destination.classController = classController
            destination.userController = userController
        }
    }
    
}

extension ClientViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetch.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetch.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClientCell", for: indexPath) as? ClientHomeTableViewCell else {return UITableViewCell()}
        
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
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = .green
        let header = view as!
        UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
    
}

extension ClientViewController: NSFetchedResultsControllerDelegate {
    
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

