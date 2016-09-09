//
//  AppDelegate.swift
//  instagram
//
//  Created by Tan Yee Gene on 08/09/2016.
//  Copyright © 2016 Tan Yee Gene. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        
        //google stuff
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        if let _ = NSUserDefaults.standardUserDefaults().objectForKey("userUID") as? String{
            let storyBoard = UIStoryboard(name:"HomeStoryboard", bundle: NSBundle.mainBundle())
            let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("FeedTabBarController")
            self.window?.rootViewController = tabBarController
        }
        return true
    }
    
    
    //google
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let user=user {
                
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                
                let firebaseRef = FIRDatabase.database().reference()
                let currentUserRef = firebaseRef.child("users").child(user.uid)
                
                guard
                    let username = user.displayName,
                    let email = user.email else { return }
                
                let userDict = ["username": username, "email": email]
                
                currentUserRef.setValue(userDict)
                
                let storyBoard = UIStoryboard(name:"HomeStoryboard", bundle:NSBundle.mainBundle())
                
                let tabBarController = storyBoard.instantiateViewControllerWithIdentifier("FeedTabBarController")
                
                self.window?.rootViewController=tabBarController
            }
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        
        
    }
    
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        if (GIDSignIn.sharedInstance().handleURL(url,sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
            annotation: options[UIApplicationOpenURLOptionsAnnotationKey])){
            return true
        }else if (FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
            annotation: options[UIApplicationOpenURLOptionsAnnotationKey])){
            return true
        }
        return false
    }
    
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

