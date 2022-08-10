//
//  detailViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 17/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    var user: User!
    var imagePartner: UIImage!
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
//    @IBAction func sendBtnDidTapped(_ sender: Any) {
//        UIApplication.shared.open(URL(string:user.coordinates)! as URL , options: [:], completionHandler: nil)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
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
                
    }
    
    
//    @IBAction func backBtnDidTap(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
    
    func setupUI() {
        
        let vanid = user.username
        
        let vidText = NSMutableAttributedString(string: vanid, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Rubik-Medium", size: 42)!, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let parragrapStyle = NSMutableParagraphStyle()
        parragrapStyle.lineSpacing = 5
        
        vidText.addAttribute(NSAttributedString.Key.paragraphStyle, value: parragrapStyle, range: NSMakeRange(0, vidText.length))
        
        usernameLbl.numberOfLines = 0
        usernameLbl.attributedText = vidText

    }
    
}

extension detailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_DETAIL, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "person.circle")
            cell.imageView?.tintColor = .systemRed
            cell.textLabel?.text = user.username
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_DETAIL, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "paperplane")
            cell.imageView?.tintColor = .systemRed
            cell.textLabel?.text = user.email
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIER_CELL_DETAIL, for: indexPath)
            cell.imageView?.image = UIImage(systemName: "pencil.and.outline")
            cell.imageView?.tintColor = .systemRed
            cell.textLabel?.text = user.status
            cell.selectionStyle = .none
            return cell

        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 300
        }
        
        return 44
    }
    
}
