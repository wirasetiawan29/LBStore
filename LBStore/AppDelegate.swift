//
//  AppDelegate.swift
//  LBStore
//
//  Created by wira on 2/1/20.
//  Copyright © 2020 Wira Setiawan. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = "843220621492-p4gsdrelqhhce6kgomjq60kfu4r6gb4m.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

      return true
    }


    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
        } else {
            print("\(error.localizedDescription)")
        }

        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
        return
    }

        let userId = user.userID
        let idToken = user.authentication.idToken!
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil,
            userInfo: ["statusText": "Signed in user:\n\(fullName!)"])

        print("Successfully logged into Google", user!)

        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

        Auth.auth().signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }

            guard let uid = user?.additionalUserInfo else { return }
            print("Successfully logged into Firebase with Google", uid)
        })
       }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

    let handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplication.OpenURLOptionsKey.annotation])

        return GIDSignIn.sharedInstance().handle(url)

    }

    func application(_ application: UIApplication,
                      open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
       return GIDSignIn.sharedInstance().handle(url)
     }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "User has disconnected."])
      
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LBStore")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

