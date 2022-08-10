//
//  UserApi.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import ProgressHUD

class UserApi {
    
    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }
    
    // MARK: - Sign In Func
    func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            print(authData?.user.uid as Any)
            onSuccess()
        }
    }
    
    // MARK: - Sign Up Func
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataRusult, error) in
            if (error != nil) {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            if let authData = authDataRusult {
                let dict: Dictionary<String, Any> = [
                    UID: authData.user.uid,
                    USERNAME: username,
                    EMAIL: authData.user.email as Any,
                    PROFILE_IMAGE_URL: "",
                    STATUS: "User"
                ]
                
                guard let imageSelected = image
                    else {
                        print("Avatar is nil")
                        ProgressHUD.showError(ERROR_EMPTY_PHOTO)
                        return
                }
                
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4)
                    else {
                        return
                }
                
                let storegeProfile = Ref().storageSpecificProfile(uid: authData.user.uid)
                
                let matadata = StorageMetadata()
                matadata.contentType = "image/jpg"
                
                StoragService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: matadata, storegeProfileRef: storegeProfile, dict: dict, onSuccess: {
                    onSuccess()
                }, onError: {
                    (errorMessage) in
                    onError(errorMessage)
                })
            }
        }
    }
    
    // MARK: - Save User Profile Func
    func saveUserProfile(dict: Dictionary<String, Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Ref().databaseSpecificUser(uid: Api.User.currentUserId).updateChildValues(dict) {
            (error, dataRef) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    // MARK: - Reset Password Func
    func resetPassword(email: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) {(error) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - Logout Func
    func logOut() {
        do {
            Api.User.isOnline(bool: false)
            try Auth.auth().signOut()
        } catch {
            ProgressHUD.showError(error.localizedDescription)
            return
        }
        (UIApplication.shared.delegate as! AppDelegate).autoLogin()
    }
    
    // MARK: - Cell User Data Func
    func observeUser(onSuccess: @escaping(UserCompletion)) {
        ProgressHUD.show("Loading...")
        Ref().databaseUser.observe(.childAdded) {
            (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transfromUser(dict: dict) {
                    onSuccess(user)
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
        ProgressHUD.show("Loading...")
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observeSingleEvent(of: .value) {
            (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transfromUser(dict: dict) {
                    onSuccess(user)
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
    func getUserInfor(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observe(.value) {
            (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transfromUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    // MARK: - Online Status Func
    func isOnline(bool: Bool) {
        if !Api.User.currentUserId.isEmpty {
            let ref = Ref().databaseIsOnline(uid: Api.User.currentUserId)
            let dict: Dictionary<String, Any> = [
                "online": bool as Any,
                "latest": Date().timeIntervalSince1970 as Any
            ]
            ref.updateChildValues(dict)
        }
    }
    
}

// MARK: - Completion
typealias UserCompletion = (User) -> Void
