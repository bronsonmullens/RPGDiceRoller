//
//  AppVersionExtension.swift
//  RPGDiceRoller
//
//  Created by Bronson Mullens on 3/22/21.
//

import UIKit

extension UIApplication {
    
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
}
