//
//  Ref.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/9/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Firebase Url
let URL_STORAGE_ROOT = "gs://vcare-8b199.appspot.com"

// MARK: - Firebase API Cloud Messaging
let API_SEVER_KEY = "AAAAMTLCQkI:APA91bF-fl_tsa5j0VS8XOc4D2Wd7Tyx48uRRV6ABQjvR2-FbnL5hVSd3RskdCpuRW4ZjRApVMzejFX5oLas8BPRjWO1Fz4_RTF7N9dQMoEkVmVQEtaAfMCoK7_PFk_PGPxcwPV4ePTu"
let API_LEGACY_SEVER_KEY = "AIzaSyBkuI_7HvOf6A-AUyMF9UjvRBYgDmJoBGU"

// MARK: - Token
let TOKET = "dYSFy8D9Qk6ClMzfYPTJN7:APA91bG8K6CDtJ6cxcgRC2oNSrPZa12VS3l3-7YLVfmM1kLnsOBYF0yIs1bX0ttsJjr8Z-tojOge9uju8MNn5tHw19wYT5AdGAqeXuCJ5fQJsRbT5Wz8w07lz263ahNYREDPLCfqZYQO"

// MARK: - Reference Admin ID
let ADMIN_ID = "RT6Cv6jhPiOBqCfPUPS4B7t6fUB2"

// MARK: - Firebase Database
let REF_ROOT = "vcare-8b199"
let REF_USER = "users"
let REF_VANS = "vans"
let STORAGE_PROFILE = "profile"

// MARK: - Reference Users
let UID = "uid"
let USERNAME = "username"
let EMAIL = "email"
let PROFILE_IMAGE_URL = "profileImageUrl"
let STATUS = "status"
let IS_ONLINE = "isOnline"

// MARK: - Reference Van
let IS_CONFIEMED = "isConfirmed"

// MARK: - Reference Van
let SHOW_CONFIRMED = "Confirmed"
let SHOW_UNCONFIRMED = "Unconfirmed"

// MARK: - Success Sign Up
let SUCCESS_SIGNIN = "SignIn success welcome back"
let SUCCESS_SIGNUP = "SingUp Success"

// MARK: - Error Sign Up
let ERROR_EMPTY_PHOTO = "Please choose your profile image"
let ERROR_EMPTY_EMAIL = "Please enter an email address"
let ERROR_EMPTY_USERNAME = "Please enter an username"
let ERROR_EMPTY_PASSWORD = "Please enter an password"

// MARK: - Error Reset
let ERROR_EMPTY_EMAIL_RESET = "Please enter an email address for password reset"

// MARK: - Success Reset
let SUCCESS_EMAIL_RESET = "We have just sent your a password reset email. Please check yuor email inbox"

// MARK: - Storyboard ID
let IDENTIFIRE_TABBAR = "tabbarID"
let IDENTIFIRE_WELCOME = "welcomeID"
let IDENTIFIER_DETAIL_USER = "detailViewController"
let IDENTIFIER_DETAIL_VAN = "minimapViewController"

// MARK: - ViewController ID
let IDENTIFIRE_CELL_USER = "userTableViewCell"
let IDENTIFIRE_CELL_VAN = "vanTableViewCell"
let IDENTIFIER_CELL_MINIMAP = "minimapDefaultCell"
let IDENTIFIER_CELL_DETAIL = "detialDefaultCell"
let IDENTIFIER_CELL_MAP = "MapCell"

// MARK: - Reference
class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    // MARK: - Users
    var databaseUser: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUser.child(uid)
    }
    
    func databaseIsOnline(uid: String) -> DatabaseReference {
        return databaseUser.child(uid).child(IS_ONLINE)
    }
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
    
    // MARK: - Vans
    var databaseVans: DatabaseReference {
        return databaseRoot.child(REF_VANS)
    }
    
    func databaseSpecificVan(vid: String) -> DatabaseReference {
           return databaseVans.child(vid)
        
    }
    func databaseIsConfirmed(vid: String) -> DatabaseReference {
        return databaseVans.child(vid).child(IS_CONFIEMED)
    }
    
}

