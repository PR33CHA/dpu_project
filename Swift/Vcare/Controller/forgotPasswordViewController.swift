//
//  forgotPasswordViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import ProgressHUD

class forgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordContainerView: UIView!
    @IBOutlet weak var forgotPasswordTextField: UITextField!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    // MARK: - UI
    func setupUI() {
        setupEmailTextField()
        setupResetPasswordButton()
    }
    
    // MARK: - Back to Sign In
    @IBAction func disimissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Reset Password Func
    @IBAction func resetPasswordDidTapped(_ sender: Any) {
        guard let email = forgotPasswordTextField.text, email != ""
            else {
                ProgressHUD.showError(ERROR_EMPTY_EMAIL_RESET)
                return
        }
        
        Api.User.resetPassword(email: email, onSuccess: {
            self.view.endEditing(true)
            ProgressHUD.showSuccess(SUCCESS_EMAIL_RESET)
            self.navigationController?.popViewController(animated: true)
        }) {(errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
}

