//
//  Van.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 1/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import Foundation

class Van {
    
    var vid: String
    var curid: String
    var date: String
    var time: String
    var coordinates: String
    var latitude: String
    var longitude: String
    var phone: String
    var isConfirm: String
    
    init(vid: String, curid: String, date: String, time: String, coordinates: String, latitude: String, longitude: String, phone: String, isConfirm: String) {
        self.vid = vid
        self.curid = curid
        self.date = date
        self.time = time
        self.coordinates = coordinates
        self.latitude = latitude
        self.longitude = longitude
        self.phone = phone
        self.isConfirm = isConfirm
    }
    
    static func transfromVan(dict: [String: Any]) -> Van? {
        guard let vid = dict["vid"] as? String,
            let curid = dict["curid"] as? String,
            let date = dict["date"] as? String,
            let time = dict["time"] as? String,
            let coordinates = dict["coordinates"] as? String,
            let latitude = dict["latitude"] as? String,
            let longitude = dict["longitude"] as? String,
            let phone = dict["phone"] as? String,
            let isConfirm = dict["isConfirm"] as? String
            else {
                return nil
        }
        
        let van = Van(vid: vid, curid: curid, date: date, time: time, coordinates: coordinates, latitude: latitude, longitude: longitude, phone: phone, isConfirm: isConfirm)
        return van
    }
    
    func updateData(key: String, value: String) {
        switch key {
        case "vid": self.vid = value
        case "curid": self.curid = value
        case "date": self.date = value
        case "time": self.time = value
        case "coordinates": self.coordinates = value
        case "latitude": self.latitude = value
        case "longitude": self.longitude = value
        case "phone": self.phone = value
        case "isConfirm": self.isConfirm = value
        default: break
        }
    }
    
}

extension Van: Equatable {
    static func == (lhs: Van, rhs: Van) -> Bool {
        return lhs.vid == rhs.vid
    }
}

