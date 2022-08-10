//
//  UIColor+Ext.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}
