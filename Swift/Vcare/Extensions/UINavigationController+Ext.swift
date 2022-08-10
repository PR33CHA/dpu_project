//
//  UINavigationController+Ext.swift
//  Vcare
//
//  Created by Preecha Jaruekklang on 3/12/2562 BE.
//  Copyright © 2562 dedodev. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    // For Xcode 9 users, childForStatusBarStyle is equal to childViewControllerForStatusBarStyle
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
