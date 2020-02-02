//
//  LoginViewController.swift
//  LBStore
//
//  Created by wira on 2/2/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class LoginViewController: UIViewController, LoginButtonDelegate, GIDSignInDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var facebookButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
        setUpUI()
    }

    func setUpData() {
        setupFacebookButtons()
        setupGoogleButtons()
    }

    func setUpUI() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        NotificationCenter.default.addObserver(self,
          selector: #selector(LoginViewController.receiveToggleAuthUINotification(_:)),
          name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
          object: nil)
        toggleAuthUI()
    }


    func toggleAuthUI() {
      if let _ = GIDSignIn.sharedInstance()?.currentUser?.authentication {
        let homeViewController = HomeViewController()
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navController
      }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
      return UIStatusBarStyle.lightContent
    }

    deinit {
      NotificationCenter.default.removeObserver(self,
          name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
          object: nil)
    }

    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
      if notification.name.rawValue == "ToggleAuthUINotification" {
        self.toggleAuthUI()
        if notification.userInfo != nil {
          guard let userInfo = notification.userInfo as? [String:String] else { return }
          self.titleLabel.text = userInfo["statusText"]!
            saveUser(self.titleLabel.text)
        }
      }
    }


    func saveUser(_ userName: String?) {
          let userDefaults = UserDefaults.standard
          userDefaults.setValue(userName, forKey: "username")
          userDefaults.synchronize()
    }

    func deleteUser() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "username")
        userDefaults.synchronize()
    }

    fileprivate func setupGoogleButtons() {

           GIDSignIn.sharedInstance()?.delegate = self
       }

    @objc func handleCustomGoogleSign() {
           GIDSignIn.sharedInstance().signIn()
       }

   fileprivate func setupFacebookButtons() {
       facebookButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
   }

    @objc func handleCustomFBLogin() {
        LoginManager().logIn(permissions: ["email"], from: self) { (result, err) in
               if err != nil {
                print("Custom FB Login failed:", err!)
                   return
               }

               self.showEmailAddress()
           }
       }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
           print("Did log out of facebook")
    }

    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
           if error != nil {
            print(error!)
               return
           }

           showEmailAddress()
       }

       func showEmailAddress() {
        let accessToken = AccessToken.current
        guard let accessTokenString = accessToken?.tokenString else { return }


        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials, completion: { (user, error) in
               if error != nil {
                   print("Something went wrong with our FB user: ", error ?? "")
                   return
               }
               print("Successfully logged in with our user: ", user ?? "")
           })

        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            if err != nil {
               print("Failed to start graph request:", err ?? "")
               return
            }
            let data = result as? [String:String]
            self.saveUser(data!["name"]!)
            let homeViewController = HomeViewController()
            let navController = UINavigationController(rootViewController: homeViewController)
            navController.isNavigationBarHidden = true
            UIApplication.shared.keyWindow?.rootViewController = navController
           }
       }

    
    @IBAction func onClickLogin(_ sender: Any) {
        let homeViewController = HomeViewController()
        let navController = UINavigationController(rootViewController: homeViewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.keyWindow?.rootViewController = navController
        saveUser("user")
    }
    
    //MARK: delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = signIn.currentUser?.authentication {
            let homeViewController = HomeViewController()
                 let navController = UINavigationController(rootViewController: homeViewController)
                 navController.isNavigationBarHidden = true
                 UIApplication.shared.keyWindow?.rootViewController = navController
        } else {
            print("error")
        }
    }

}
