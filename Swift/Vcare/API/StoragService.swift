//
//  StoragService.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import Foundation

import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD

class StoragService {
    
    // MARK: - Save Photo (Profile View)
    static func savePhotoProfile(image: UIImage, uid: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4)
            else {
                return
        }
        
        let storegeProfileRef = Ref().storageSpecificProfile(uid: uid)
        
        let matadata = StorageMetadata()
        matadata.contentType = "image/jpg"
        
        storegeProfileRef.putData(imageData, metadata: matadata, completion: { (storageMetaData, error) in
                    if error != nil {
                        onError(error!.localizedDescription)
                        return
                    }
                    storegeProfileRef.downloadURL(completion: { (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                            
                            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                                changeRequest.photoURL = url
//                                changeRequest.displayName = username
                                changeRequest.commitChanges(completion: {(error) in
                                    if let error = error {
                                        ProgressHUD.showError(error.localizedDescription)
                                    }
                                    NotificationCenter.default.post(name: NSNotification.Name("updateProfileImage"), object: nil)
                                })
                            }
                            
//                            var dictTamp = dict
//                            dictTamp[PROFILE_IMAGE_URL] = metaImageUrl
                            Ref().databaseSpecificUser(uid: uid).updateChildValues([PROFILE_IMAGE_URL: metaImageUrl], withCompletionBlock: {
                                (error, ref) in
                                if error == nil {
                                    onSuccess()
        //                            print("Done")
                                } else {
                                    onError(error!.localizedDescription)
                                }
                            })
                        }
                    })
                })
        
    }
    
    // MARK: - Save Photo (SingUp View)
    static func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storegeProfileRef: StorageReference, dict: Dictionary<String, Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storegeProfileRef.putData(data, metadata: metadata, completion: { (storageMetaData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storegeProfileRef.downloadURL(completion: {
                (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges(completion: {
                            (error) in
                            if let error = error {
                                ProgressHUD.showError(error.localizedDescription)
                            }
                        })
                    }
                    
                    var dictTamp = dict
                    dictTamp[PROFILE_IMAGE_URL] = metaImageUrl
                    Ref().databaseSpecificUser(uid: uid).updateChildValues(dictTamp, withCompletionBlock: {
                        (error, ref) in
                        if error == nil {
                            onSuccess()
//                            print("Done")
                        } else {
                            onError(error!.localizedDescription)
                        }
                    })
                }
            })
        })
        
    }
}
