//
//  LoginViewController.swift
//  My Car
//
//  Created by Axel Lefaux on 03/03/2018.
//  Copyright © 2018 ITomorrow. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error!.localizedDescription)
            
            return
        }
        
        print(user.authentication)
        // Log with Google
        ConnexionHelper.helper.logInWithGoogle(authentification: user.authentication)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().clientID = "1048697655603-oocu0v1fm938mudemaj86rjgno666vph.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        switchToNavigationViewController()
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        switchToNavigationViewController()
    }
    
    func switchToNavigationViewController() {
        print("View change")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationViewController
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
