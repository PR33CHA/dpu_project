//
//  vansTableViewCell.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 1/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import Firebase

protocol UpdateVanTableProtocol {
    func reloadData()
}

class vansTableViewCell: UITableViewCell {

    @IBOutlet weak var vansDateLbl: UILabel!
    @IBOutlet weak var vansTimeLbl: UILabel!
    @IBOutlet weak var vansVidLbl: UILabel!
    
    @IBOutlet weak var avt: UIImageView!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var confirmMark: UIImageView!
    
    var van: Van!
    var changedOnlineHandle: DatabaseHandle!
    var changedProfileHandle: DatabaseHandle!
    var controller: trayTableViewController!
    
    override func awakeFromNib() {
//        checkMark()
        
//        print("aaaaaaaaaa: \(van.isConfirm)")
        
        super.awakeFromNib()
        
        avt.layer.cornerRadius = 40
        avt.clipsToBounds = true
        
        card.layer.cornerRadius = 10.0
        card.clipsToBounds = true

    }
    
    func loadDataVan (_ van:Van) {
        self.van = van
        self.vansDateLbl.text = van.date
        self.vansTimeLbl.text = van.time
        self.vansVidLbl.text = van.curid
        
        self.avt.image = UIImage(named: "protovan")
        
        if van.isConfirm == "Unconfirmed" {
            confirmMark.image = UIImage(systemName: "xmark.circle")
            confirmMark.tintColor = .systemRed
            vansVidLbl.textColor = .systemRed
        }
        else if van.isConfirm == "Confirmed" {
            confirmMark.image = UIImage(systemName: "checkmark.circle")
            confirmMark.tintColor = .systemGreen
            vansVidLbl.textColor = .systemGreen
        }
        
        let refVan = Ref().databaseSpecificVan(vid: van.vid)
        if changedProfileHandle != nil {
            refVan.removeObserver(withHandle: changedProfileHandle)
        }
        
        changedProfileHandle = refVan.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String {
                self.van.updateData(key: snapshot.key, value: snap)
                self.controller.tableView.reloadData()
            }
        })

        
    }
    
//    func checkMark() {
//        if van.isConfirm == "Unconfirmed" {
//            confirmMark.image = UIImage(systemName: "xmark.rectangle")
//            confirmMark.tintColor = .systemRed
//        }
//        else if van.isConfirm == "Confirmed" {
//            confirmMark.image = UIImage(systemName: "checkmark.rectangle")
//            confirmMark.tintColor = .systemGreen
//        }
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        let refVan = Ref().databaseSpecificVan(vid: self.van.vid)
        if changedProfileHandle != nil {
            refVan.removeObserver(withHandle: changedProfileHandle)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
