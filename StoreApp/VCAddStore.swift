//
//  VCAddStore.swift
//  StoreApp
//
//  Created by Med Salmen Saadi on 4/29/18.
//  Copyright © 2018 Med Salmen Saadi. All rights reserved.
//

import UIKit

class VCAddStore: UIViewController {

    @IBOutlet weak var tf_StoreName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func bu_Save(_ sender: Any) {
        if tf_StoreName.text == "" {
            //Alert
            let alert = UIAlertController(title: "Empty Store ..!", message: "Please add a new Store Name", preferredStyle: .alert)
            let accept = UIAlertAction(title: "I Understand", style: .default) { (action) in
                
                print("accepted")
            }
            alert.addAction(accept)
            present(alert, animated: true, completion: nil)
        }
        else {
            //ActionSheet
            let actionSheet = UIAlertController(title: "Save", message: "Do you really want to save ?", preferredStyle: .actionSheet)
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                let store=StoreType(context: context)
                store.name=self.tf_StoreName.text
                //do{
                    ad.saveContext()
                    self.tf_StoreName.text=""
                    print("saved")
                //}catch{
                    //print("cannot save")
                //}
                print("save")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                print("cancell")
            }
            actionSheet.addAction(saveAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true, completion: nil)
        }
        /*let store=StoreType(context: context)
        store.name=tf_StoreName.text
        do{
            ad.saveContext()
            tf_StoreName.text=""
            print("saved")
        }catch{
            print("cannot save")
        }*/
    }
    
    @IBAction func bu_Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
