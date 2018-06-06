//
//  ViewController.swift
//  StoreApp
//
//  Created by Med Salmen Saadi on 4/28/18.
//  Copyright © 2018 Med Salmen Saadi. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var tv_items: UITableView!
    
    var controller:NSFetchedResultsController<Items>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tv_items.dataSource=self
        tv_items.delegate=self
        
        loadIetms()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections =  controller.sections {
            let sectionInfo=sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
            as! TVCell
        configureCell(cell: cell, indexPath: indexPath)
        return cell
        
    }
    
    func loadIetms() {
        
        let fetchRequest:NSFetchRequest<Items>=Items.fetchRequest()
        
        //sort by date
        let  date_addSort=NSSortDescriptor(key: "date_add", ascending: true)
        fetchRequest.sortDescriptors=[date_addSort]
        
        controller=NSFetchedResultsController(fetchRequest:fetchRequest , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate=self
        do{
            try controller.performFetch()
        }catch{
            print("error")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tv_items.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tv_items.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // data fetch
        switch(type) {
            
        case.insert:
            if let indexPath = newIndexPath {
                tv_items.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tv_items.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tv_items.cellForRow(at: indexPath) as! TVCell
                configureCell(cell: cell, indexPath: indexPath )
            }
            break
        case.move:
            if let indexPath = indexPath {
                tv_items.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tv_items.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        }
    }
    func configureCell(cell:TVCell,indexPath:IndexPath)     {
        let Singleitem=controller.object(at: indexPath )
        cell.setMyCell(item:Singleitem)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  let objc=controller.fetchedObjects{
            let item=objc[indexPath.row]
            performSegue(withIdentifier: "EditOrDelete", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="EditOrDelete" {
            if let destination=segue.destination as? VCAddItem {
                if let item=sender as? Items {
                    destination.EditOrDeleteItem=item
                }
            }
        }
    }
    
}

