//
//  VCAddItem.swift
//  StoreApp
//
//  Created by Med Salmen Saadi on 4/29/18.
//  Copyright © 2018 Med Salmen Saadi. All rights reserved.
//

import UIKit
import CoreData

class VCAddItem: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource,
UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tf_ToolName: UITextField!
    @IBOutlet weak var iv_ToolImage: UIImageView!
    @IBOutlet weak var pv_SotreType: UIPickerView!
    
    var ListStoreType=[StoreType]()
    var imagePicker:UIImagePickerController!
    var EditOrDeleteItem:Items?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        pv_SotreType.dataSource=self
        pv_SotreType.delegate=self
        
        imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        
        LoadStoes()
        if EditOrDeleteItem != nil {
            LoadForEdit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        print("viewWillAppear")
        
        pv_SotreType.dataSource=self
        pv_SotreType.delegate=self
        
        LoadStoes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // start picker view implement
    func LoadStoes() {
        let fecthRequest:NSFetchRequest<StoreType>=StoreType.fetchRequest()
        do{
            ListStoreType=try context.fetch(fecthRequest)
        }catch{
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ListStoreType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store=ListStoreType[row]
        return store.name
    }
    // end picker view implement
    
    // start image picker implement
    @IBAction func bu_SelectImage(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            iv_ToolImage.image=image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    // end image picker implement
    
    @IBAction func bu_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func bu_Save(_ sender: Any) {
        if (ListStoreType.count==0) {
            //Alert
            let alert = UIAlertController(title: "Empty Store ..!", message: "Please add a new Store before adding an Item ?", preferredStyle: .alert)
            let nav = UIAlertAction(title: "Go", style: .default) { (action) in
                
                self.performSegue(withIdentifier: "addStore", sender: self)
                print("navigate")
            }
            let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                print("cancelled")
            }
            alert.addAction(nav)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        else {
                //ActionSheet
                let actionSheet = UIAlertController(title: "Save", message: "Do you really want to save ?", preferredStyle: .actionSheet)
                let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                    self.Save()
                    print("save")
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                    print("cancell")
                }
                actionSheet.addAction(saveAction)
                actionSheet.addAction(cancelAction)
                present(actionSheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func bu_Delete(_ sender: Any) {
        
        if EditOrDeleteItem != nil {
            
            //Alert
            let alert = UIAlertController(title: "Delete", message: "Do you really want to delete ?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                context.delete(self.EditOrDeleteItem! )
                ad.saveContext()
                //_ =  navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                print("delete")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                print("cancel")
            }
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        else {
            //Alert
            let alert = UIAlertController(title: "Item Not Found ..!", message: "No Selected Item to delete it", preferredStyle: .alert)
            let accept = UIAlertAction(title: "I Understand", style: .default) { (action) in
                
                print("accepted")
            }
            alert.addAction(accept)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func Save() {
        let newItem:Items!
        
        if EditOrDeleteItem == nil {
            newItem=Items(context: context)
        }else{
            newItem=EditOrDeleteItem
        }
        
        newItem.item_name=tf_ToolName.text
        newItem.date_add=NSDate() as Date
        newItem.image=iv_ToolImage.image
        newItem.toStore=ListStoreType[pv_SotreType.selectedRow(inComponent: 0)]
        //do{
            ad.saveContext()
            tf_ToolName.text=""
            print("saved")
        //} catch
        //{
            //print("cannot save")
        //}
    }
    
    func   LoadForEdit() {
        if let item = EditOrDeleteItem{
            tf_ToolName.text=item.item_name
            iv_ToolImage.image=item.image as? UIImage
            
            if let store=item.toStore {
                var index=0
                while index<ListStoreType.count {
                    let row=ListStoreType[index]
                    if row.name==store.name{
                        pv_SotreType.selectRow(index, inComponent: 0, animated: false)
                    }
                    index=index+1
                }
            }
        }
        
    }
    
}
