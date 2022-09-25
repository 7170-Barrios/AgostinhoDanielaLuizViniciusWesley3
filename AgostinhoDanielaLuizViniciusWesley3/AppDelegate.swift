//
//  AppDelegate.swift
//  AgostinhoDanielaLuizViniciusWesley3
//
//  Created by Agostinho José Schlindwein on 25/09/22.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }


}

