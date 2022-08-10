//
//  userTableViewCell.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 30/11/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

protocol UpdateTableProtocol {
    func reloadData()
}

class userTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var onlineView: UIView!
    
    var user: User!
    var changedOnlineHandle: DatabaseHandle!
    var changedProfileHandle: DatabaseHandle!
    var controller: peopleTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.layer.cornerRadius = 30
        avatar.clipsToBounds = true
        
        card.layer.cornerRadius = 10.0
        card.clipsToBounds = true
        
        onlineView.backgroundColor = UIColor.red
        onlineView.layer.borderWidth = 2
        onlineView.layer.borderColor = UIColor.white.cgColor
        onlineView.layer.cornerRadius = 15/2
        onlineView.clipsToBounds = true
        
    }
    
    func loadData (_ user:User) {
        self.user = user
        self.usernameLbl.text = user.username
        self.statusLbl.text = user.status
        self.avatar.loadImage(user.profileImageUrl)
        
        let refOnline = Ref().databaseIsOnline(uid: user.uid)
        refOnline.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String, Any> {
                if let active = snap["online"] as? Bool {
                    self.onlineView.backgroundColor = active == true ? .green : .red
                }
            }
        }
        if changedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: changedOnlineHandle)
        }
        
        changedOnlineHandle = refOnline.observe(.childChanged) { (snapshot) in
            if let snap = snapshot.value {
                if snapshot.key == "online" {
                    self.onlineView.backgroundColor = (snap as! Bool) == true ? .green : .red
                }
            }
        }
        
        let refUser = Ref().databaseSpecificUser(uid: user.uid)
        if changedProfileHandle != nil {
            refUser.removeObserver(withHandle: changedProfileHandle)
        }
        
        changedProfileHandle = refUser.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String {
                self.user.updateData(key: snapshot.key, value: snap)
                self.controller.tableView.reloadData()
            }
        })
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let refOnline = Ref().databaseIsOnline(uid: self.user.uid)
        if changedOnlineHandle != nil {
            refOnline.removeObserver(withHandle: changedOnlineHandle)
        }
        
        let refUser = Ref().databaseSpecificUser(uid: self.user.uid)
        if changedProfileHandle != nil {
            refUser.removeObserver(withHandle: changedProfileHandle)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
