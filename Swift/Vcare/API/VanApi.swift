//
//  VanApi.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 1/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import Foundation
import ProgressHUD
import Firebase
import FirebaseAuth

class VanApi {
    
    // MARK: - Cell Van Data Func
    func observeVan(onSuccess: @escaping(VanCompletion)) {
        ProgressHUD.show("Loading...")
        Ref().databaseVans.observe(.childAdded) {
            (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let van = Van.transfromVan(dict: dict) {
                    onSuccess(van)
                    ProgressHUD.dismiss()
                }
            }
        }
    }
    
//    func isOnline(bool: Bool) {
//        if !Api.User.currentUserId.isEmpty {
//            let ref = Ref().databaseIsOnline(uid: Api.User.currentUserId)
//            let dict: Dictionary<String, Any> = [
//                "online": bool as Any,
//                "latest": Date().timeIntervalSince1970 as Any
//            ]
//            ref.updateChildValues(dict)
//        }
//    }
    
}
// MARK: - Completion
typealias VanCompletion = (Van) -> Void
