//
//  profileTableViewController.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 30/11/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit
import ProgressHUD

class profileTableViewController: UITableViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var usernameTextFild: UITextField!
    @IBOutlet weak var emailTextFild: UITextField!
    @IBOutlet weak var statusTextFild: UITextField!
    
    @IBOutlet weak var userStatusTextFild: UILabel!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeData()
        userStatus()
        
        self.userStatusTextFild.layer.cornerRadius = 5
        self.userStatusTextFild.clipsToBounds = true
        
    }
    
    func setupView() {
        setupAvatar()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(disimissKeyboard)))
    }
    
    @objc func disimissKeyboard() {
        view.endEditing(true)
    }
    
    func setupAvatar() {
        avatar.layer.cornerRadius = 50
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        
        let tapGestTrue = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        
        avatar.addGestureRecognizer(tapGestTrue)
    }
    
    func userStatus() {
        if Api.User.currentUserId == (ADMIN_ID) {
            userStatusTextFild.text = "Admin"
            userStatusTextFild.backgroundColor = .systemRed
            avatar.layer.borderWidth = 2
            avatar.layer.borderColor = UIColor.systemRed.cgColor
        } else {
            avatar.layer.borderWidth = 2
            avatar.layer.borderColor = UIColor.systemGreen.cgColor
        }
    }
    
    @objc func presentPicker() {
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func observeData() {
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.usernameTextFild.text = user.username
            self.emailTextFild.text = user.email
            self.statusTextFild.text = user.status
            self.avatar.loadImage(user.profileImageUrl)
        }
    }
    
    // MARK: - Log Out
    @IBAction func logoutButtonDidTapped(_ sender: Any) {
        Api.User.logOut()
    }
    
    // MARK: - Svae Profile
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        ProgressHUD.show("Loading...")
        
        var dict = Dictionary<String, Any>()
        if let username = usernameTextFild.text, !username.isEmpty {
            dict["username"] = username
        }
        if let email = emailTextFild.text, !email.isEmpty {
            dict["email"] = email
        }
        if let status = statusTextFild.text, !status.isEmpty {
            dict["status"] = status
        }
        
        Api.User.saveUserProfile(dict: dict, onSuccess: {
            if let img = self.image {
                StoragService.savePhotoProfile(image: img, uid: Api.User.currentUserId, onSuccess: {
                    ProgressHUD.showSuccess()
                }) { (errorMessage) in
                    ProgressHUD.showError(errorMessage)
                }
            } else {
                ProgressHUD.showSuccess("Success")
            }
        }) { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        }
    }
    
}

// MARK: - Profile Avatar Original image
extension profileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSlected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSlected
            avatar.image = imageSlected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            avatar.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
