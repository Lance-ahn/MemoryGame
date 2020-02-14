//
//  AppDelegate.swift
//  Hackathon_2nd_SamePicturePuzzle
//
//  Created by MyMac on 2020/02/03.
//  Copyright © 2020 sandMan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navi = UINavigationController()
        let mainView = SelectStageViewController()
        navi.viewControllers = [mainView]
        
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

