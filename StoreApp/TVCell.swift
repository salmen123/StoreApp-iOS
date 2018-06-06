//
//  TVCell.swift
//  StoreApp
//
//  Created by Med Salmen Saadi on 4/28/18.
//  Copyright © 2018 Med Salmen Saadi. All rights reserved.
//

import UIKit

class TVCell: UITableViewCell {

    @IBOutlet weak var la_StoreName: UILabel!
    @IBOutlet weak var la_DateAdded: UILabel!
    @IBOutlet weak var iv_Image: UIImageView!
    @IBOutlet weak var la_ItemName: UILabel!
    
    func setMyCell(item:Items) {
        if (item.toStore?.name == "") {
            la_StoreName.text="No Store"
        }
        else {
            la_StoreName.text=item.toStore?.name
        }
        
        if (item.item_name == "") {
            la_ItemName.text="No Name"
        }
        else {
            la_ItemName.text=item.item_name
        }
        
        iv_Image.image=item.image as? UIImage
        
        // convert date to string
        let dateformat=DateFormatter()
        dateformat.dateFormat="MM/DD/yy h:mm a"
        la_DateAdded.text=dateformat.string(from: item.date_add!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
