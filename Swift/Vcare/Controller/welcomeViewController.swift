//
//  welcomeViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 2/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import ProgressHUD

import Firebase
import FirebaseAuth

class welcomeViewController: UIViewController { 
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var emailContainterView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordContainterView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var orLabel: UILabel!
    
    // MARK: - 1st
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI
    func setupUI() {
        let title = "Vcare"
        let subTitle = "\n" + "เข้าสู่ระบบเพื่อใช้งาน"
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Rubik-Medium", size: 42)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        
        let attributedSubText = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Opun-Regular", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        attributedText.append(attributedSubText)
        
        let parragrapStyle = NSMutableParagraphStyle()
        parragrapStyle.lineSpacing = 5
        
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: parragrapStyle, range: NSMakeRange(0, attributedText.length))
        
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = attributedText
        
        orLabel.text = "Or"
        orLabel.font = UIFont.boldSystemFont(ofSize: 16)
        orLabel.textColor = UIColor.gray
        orLabel.textAlignment = .center
        
        setupEmailTextField()
        setupPasswordTextField()
        setupSignInButton()
        setupSignUpButton()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//      super.viewDidAppear(animated)
//        AppManager.shared.appContainer = self
//        AppManager.shared.showApp()
//    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.signIn(onSuccess: {
            Api.User.isOnline(bool: true)
            (UIApplication.shared.delegate as! AppDelegate).autoLogin()
        }) {(errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
}
