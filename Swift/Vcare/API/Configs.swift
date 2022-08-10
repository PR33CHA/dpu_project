//
//  Configs.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 30/1/2563 BE.
//  Copyright © 2563 dedodev. All rights reserved.
//

import Foundation

let serverKey = "AAAAMTLCQkI:APA91bF-fl_tsa5j0VS8XOc4D2Wd7Tyx48uRRV6ABQjvR2-FbnL5hVSd3RskdCpuRW4ZjRApVMzejFX5oLas8BPRjWO1Fz4_RTF7N9dQMoEkVmVQEtaAfMCoK7_PFk_PGPxcwPV4ePTu"

let fcmUrl = "https://fcm.googleapis.com/fcm/send"

func sendRequestNotification(fromUser: User, toUser: User, message: String, badge: Int) {
    var request = URLRequest(url: URL(string: fcmUrl)!)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "POST"
    
    let notification: [String: Any] = [ "to" : "/topics/\(toUser.uid)",
        "notification" : ["title": fromUser.username,
                          "body": message,
                          "sound" : "default",
                          "badge": badge
        ]
    ]
    
    let data = try! JSONSerialization.data(withJSONObject: notification, options: [])
    request.httpBody = data
    
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) in
        guard let data = data, error == nil else {
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            print("HttpUrlResponse \(httpResponse.statusCode)")
            print("Response \(response!)")
        }
        
        if let responseString = String(data: data, encoding: String.Encoding.utf8) {
            print("ResponseString \(responseString)")
        }
        }.resume()
    
}

