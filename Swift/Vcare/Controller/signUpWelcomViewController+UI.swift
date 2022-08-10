//
//  signUpWelcomViewController+UI.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 2/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import ProgressHUD

extension signUpWelcomViewController {
    
    
    // MARK: - Title "Sign Up"
    func setupTitleTextLabel(){
        let title = "Sign Up"
        
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.init(name: "Rubik-Medium", size: 28)!, NSAttributedString.Key.foregroundColor: UIColor.black])
        
        titleTextLabel.attributedText = attributedText
    
    }
    
    // MARK: - Avatar
    func setupAvatarImageView() {
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        
        let tapGestTrue = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        
        avatarImageView.addGestureRecognizer(tapGestTrue)
    }
    
    // MARK: - @objc Profile Avatar
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Full Name
    func setupFullnameTextField() {
        fullnameContainterView.layer.borderWidth = 1
        fullnameContainterView.layer.borderColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1).cgColor
        fullnameContainterView.layer.cornerRadius = 25
        fullnameContainterView.clipsToBounds = true
        
        fullnameTextField.borderStyle = .none
        
        let placehoderAttr = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)])
        
        fullnameTextField.attributedPlaceholder = placehoderAttr
        fullnameTextField.textColor = UIColor(red: 0/255, green: 0/25, blue: 0/255, alpha: 1)
    
    }
    
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
    
    // MARK: - Sign Up
    func setupSignUpButton() {
        signUpButton.setTitle("Confirm", for: UIControl.State.normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.backgroundColor = UIColor.black /* init(red:99, green:51, blue:4) deep mocha */
        signUpButton.layer.cornerRadius = 25
        signUpButton.clipsToBounds = true
        signUpButton.setTitleColor(.white, for: UIControl.State.normal)
    }
    
    // MARK: - Touch End
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func validateFields() {
        guard let username = self .fullnameTextField.text, !username.isEmpty
            else {
                ProgressHUD.showError(ERROR_EMPTY_USERNAME)
                return
        }
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
    
    func signUp(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show("Loading...")
        Api.User.signUp(withUsername: self.fullnameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, image: self.image, onSuccess: {
            ProgressHUD.dismiss()
//            ProgressHUD.showSuccess(SUCCESS_SIGNUP)
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
}
        
//        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (authDataRusult, error) in
//            if (error != nil) {
//                ProgressHUD.showError(error!.localizedDescription)
//                return
//            }
//            if let authData = authDataRusult {
//                print(authData.user.email)
//                var dict: Dictionary<String, Any> = [
//                    "uid": authData.user.uid,
//                    "username": self.emailTextField.text,
//                    "email": authData.user.email,
//                    "profileImageUrl": "",
//                    "status": "Welcome to Vcare"
//                ]
//
//                let storegeRef = Storage.storage().reference(forURL: "gs://vcare-8b199.appspot.com")
//
//                let storegeProfileRef = storegeRef.child("profile").child(authData.user.uid)
//
//                let matadata = StorageMetadata()
//                matadata.contentType = "image/jpg"
//                storegeProfileRef.putData(imageData, metadata: matadata, completion: {
//                    (StorageMetadata, error) in
//                    if error != nil {
//                        print(error?.localizedDescription)
//                        return
//                    }
//                    storegeProfileRef.downloadURL(completion: { (url, error) in
//                        if let metaImageUrl = url?.absoluteString {
//                            dict["profileImageUrl"] = metaImageUrl
//                            Database.database().reference().child("users").child(authData.user.uid).updateChildValues(dict, withCompletionBlock: {
//                                (error, ref) in
//                                if error == nil {
//                                    print("Done")
//                                }
//                            })
//                        }
//                    })
//                })
//            }
//        }

// MARK: - Profile Avatar Original image
extension signUpWelcomViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSlected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSlected
            avatarImageView.image = imageSlected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            avatarImageView.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
