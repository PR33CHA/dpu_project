//
//  forgotPasswordViewController+UI.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit

extension forgotPasswordViewController {
    
    // MARK: - Email Address
    func setupEmailTextField() {
        forgotPasswordContainerView.layer.borderWidth = 1
        forgotPasswordContainerView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        forgotPasswordContainerView.layer.cornerRadius = 25
        forgotPasswordContainerView.clipsToBounds = true
        
        forgotPasswordTextField.borderStyle = .none
        
        let placehoderAttr = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        forgotPasswordTextField.attributedPlaceholder = placehoderAttr
        forgotPasswordTextField.textColor = UIColor(red: 0/255, green: 0/25, blue: 0/255, alpha: 1)
    }
    
    // MARK: - Sign Up
    func setupResetPasswordButton() {
        resetPasswordButton.setTitle("Reset my password", for: UIControl.State.normal)
        resetPasswordButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        resetPasswordButton.backgroundColor = UIColor.black /* init(red:99, green:51, blue:4) deep mocha */
        resetPasswordButton.layer.cornerRadius = 25
        resetPasswordButton.clipsToBounds = true
        resetPasswordButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    
    // MARK: - Touch end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
