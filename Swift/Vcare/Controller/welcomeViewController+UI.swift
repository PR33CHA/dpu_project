//
//  welcomeViewController+UI.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import ProgressHUD

extension welcomeViewController {
    
    // MARK: - Email Address
    func setupEmailTextField() {
        emailContainterView.layer.borderWidth = 1
        emailContainterView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        emailContainterView.layer.cornerRadius = 25
        emailContainterView.clipsToBounds = true
        
        emailTextField.borderStyle = .none
        
        let placehoderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        emailTextField.attributedPlaceholder = placehoderAttr
        emailTextField.textColor = UIColor(red: 0/255, green: 0/25, blue: 0/255, alpha: 1)
    }
    
    // MARK: - Password
    func setupPasswordTextField() {
        passwordContainterView.layer.borderWidth = 1
        passwordContainterView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        passwordContainterView.layer.cornerRadius = 25
        passwordContainterView.clipsToBounds = true
        
        passwordTextField.borderStyle = .none
        
        let placehoderAttr = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        passwordTextField.attributedPlaceholder = placehoderAttr
        passwordTextField.textColor = UIColor(red: 0/255, green: 0/25, blue: 0/255, alpha: 1)
    }
    
    // MARK: - Sign In
    func setupSignInButton() {
        signInButton.setTitle("Sign In", for: UIControl.State.normal)
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signInButton.backgroundColor = UIColor.black /* init(red:99, green:51, blue:4) deep mocha */
        signInButton.layer.cornerRadius = 25
        signInButton.clipsToBounds = true
        signInButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    
    // MARK: - Sign Up
    func setupSignUpButton() {
        signUpButton.setTitle("Create new account", for: UIControl.State.normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.backgroundColor = UIColor.black /* init(red:99, green:51, blue:4) deep mocha */
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        signUpButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    
    // MARK: - Touch end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func validateFields() {
        guard let email = self .emailTextField.text, !email.isEmpty
            else {
                ProgressHUD.showError(ERROR_EMPTY_EMAIL)
                return
        }
        guard let password = self .passwordTextField.text, !password.isEmpty
            else {
                ProgressHUD.showError(ERROR_EMPTY_PASSWORD)
                return
        }
    }
    
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show("Loading...")
        Api.User.signIn(email: self.emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.dismiss()
//            ProgressHUD.showSuccess(SUCCESS_SIGNIN)
            onSuccess()
        }) {(errorMessage) in
            onError(errorMessage)
        }
    }
}
