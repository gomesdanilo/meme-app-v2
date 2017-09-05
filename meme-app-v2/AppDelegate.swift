//
//  AppDelegate.swift
//  meme-app-v1
//
//  Created by Danilo Gomes on 04/09/2017.
//  Copyright © 2017 Danilo Gomes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes : [Meme] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    static func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

