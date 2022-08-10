//
//  minimapViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth
import ProgressHUD

protocol UpdateMinimapProtocol {
    func reloadData()
}

class minimapViewController: UIViewController {
    
    var keyArray: [String] = []
    var vans: [Van] = []
    var van: Van!
    var user: User!
    var imagePartner: UIImage!
    
    var changedIsConfirmHandle: DatabaseHandle!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var curidLbl: UILabel!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func sendBtnDidTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string:van.coordinates)! as URL , options: [:], completionHandler: nil)
    }
    
    @IBAction func confirmBtnDidTapped(_ sender: Any) {

        if van.isConfirm == "Confirmed" {
            Ref().databaseVans.child(van.vid).updateChildValues(["isConfirm": "Unconfirmed"])
            confirmBtn.backgroundColor = .systemRed
            confirmBtn.setTitle("Unconfirmed", for: UIControl.State.normal)
            ProgressHUD.showError(SHOW_UNCONFIRMED)
            
        } else if van.isConfirm == "Unconfirmed" {
            Ref().databaseVans.child(van.vid).updateChildValues(["isConfirm": "Confirmed"])
            confirmBtn.backgroundColor = .systemGreen
            confirmBtn.setTitle("Confirmed", for: UIControl.State.normal)
            ProgressHUD.showSuccess(SHOW_CONFIRMED)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        adminBtnVerify()
        confirmBtnUI()
        
        googleBtn.layer.cornerRadius = 5
        googleBtn.clipsToBounds = true
        
        confirmBtn.layer.cornerRadius = 5
        confirmBtn.clipsToBounds = true
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.delegate = self
        
        avatar.clipsToBounds = true
        avatar.image = imagePartner
        
        let frameGradient = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 350)
        avatar.addBlackGradientLayer(frame: frameGradient, colors: [.clear, .black])
     
        let backButton = UIImage(named: "back")
        self.navigationController?.navigationBar.backIndicatorImage = backButton
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
        
        let backText = UIBarButtonItem()
        backText.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backText
        
        let refVan = Ref().databaseSpecificVan(vid: van.vid)
        if changedIsConfirmHandle != nil {
            refVan.removeObserver(withHandle: changedIsConfirmHandle)
        }
        
        changedIsConfirmHandle = refVan.observe(.childChanged, with: { (snapshot) in
            if let snap = snapshot.value as? String {
                self.van.updateData(key: snapshot.key, value: snap)
                self.tableView.reloadData()
            }
        })
        
    }
    
//    @IBAction func backBtnDidTap(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
    
    func adminBtnVerify() {
         if Api.User.currentUserId != (ADMIN_ID) {
            confirmBtn.isHidden = true
         }
     }
    
    func confirmBtnUI() {
        confirmBtn.setTitle(van.isConfirm, for: UIControl.State.normal)
        if van.isConfirm == "Confirmed" {
            confirmBtn.backgroundColor = UIColor.systemGreen
        } else if van.isConfirm == "Unconfirmed" {
            confirmBtn.backgroundColor = UIColor.systemRed
        }
    }
    
    func setupUI() {
        
        let vanid = van.curid
        
        let vidText = NSMutableAttributedString(string: vanid, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Rubik-Medium", size: 42)!, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let parragrapStyle = NSMutableParagraphStyle()
        parragrapStyle.lineSpacing = 5
        
        vidText.addAttribute(NSAttributedString.Key.paragraphStyle, value: parragrapStyle, range: NSMakeRange(0, vidText.length))
        
        curidLbl.numberOfLines = 0
        curidLbl.attributedText = vidText

    }
    
}


extension minimapViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MINIMAP, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "person")
            cell.imageView?.tintColor = .systemRed
            cell.textLabel?.text = van.curid
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MINIMAP, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "phone")
            cell.imageView?.tintColor = .systemRed
            cell.textLabel?.text = van.phone
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MINIMAP, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "map")
            cell.imageView?.tintColor = .systemRed
            if !van.latitude.isEmpty, !van.longitude.isEmpty {
                let location = CLLocation(latitude: CLLocationDegrees(Double(van.latitude)!), longitude: CLLocationDegrees(Double(van.longitude)!))
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    if error == nil, let placemarksArray = placemarks, placemarksArray.count > 0 {
                        if let placemark = placemarksArray.last {
                            var text = ""
                            if let thoroughFare = placemark.thoroughfare {
                                text = "\(thoroughFare)"
                                cell.textLabel?.text = text
                            }
                            if let postalCode = placemark.postalCode {
                                text = text + " " + postalCode
                                cell.textLabel?.text = text
                            }
                            if let locality = placemark.locality {
                                text = text + " "  + locality
                                cell.textLabel?.text = text
                            }
                            if let country = placemark.country {
                                text = text + " "  + country
                                cell.textLabel?.text = text
                            }
                        }
                    }
                }
            }
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MINIMAP, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "calendar")
            cell.imageView?.tintColor = .systemRed
            cell.textLabel?.text = van.date
            cell.selectionStyle = .none
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MINIMAP, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "clock")
            cell.imageView?.tintColor = .systemRed
            cell.textLabel?.text = van.time
            cell.selectionStyle = .none
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_MAP, for: indexPath) as! MapTableViewCell
            cell.controller = self
            if !van.latitude.isEmpty, !van.longitude.isEmpty {
                let location = CLLocation(latitude: CLLocationDegrees(Double(van.latitude)!), longitude: CLLocationDegrees(Double(van.longitude)!))
                cell.configure(location: location)
            }
            cell.selectionStyle = .none

        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5 {
            return 300
        }
        
        return 44
    }
    
}

