//
//  SplashViewController.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkNextScreen()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkNextScreen()
    }

    // MARK: - private function
    func checkNextScreen() {
        let user = UserDefaults.standard.object(forKey: "username") as? Bool ?? false
        if user {
            self.openHomeScreen()
        } else {
            self.openLandingScreen()
        }
    }

    func openLandingScreen() {
        let loginViewController = LoginViewController()
        let navController = UINavigationController(rootViewController: loginViewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navController
    }

    func openHomeScreen() {

        let homeViewController = HomeViewController()
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navController
    }
}
