//
//  signUpWelcomViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 2/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

// Storage: (gs://vcare-8b199.appspot.com)

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class signUpWelcomViewController: UIViewController {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var fullnameContainterView: UIView!
    @IBOutlet weak var fullnameTextField: UITextField!
    
    @IBOutlet weak var emailContainterView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordContainterView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var image: UIImage? = nil
    
    // MARK: - 1st
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI
    func setupUI() {
        setupTitleTextLabel()
        setupAvatarImageView()
        setupFullnameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupSignUpButton()
    }
    
    // MARK: - Back to Sign In
    @IBAction func disimissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
    }
    
    // MARK: - Sign Up Func
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.signUp(onSuccess: {
            Api.User.isOnline(bool: true)
            (UIApplication.shared.delegate as! AppDelegate).autoLogin()
        }) {(errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
}


