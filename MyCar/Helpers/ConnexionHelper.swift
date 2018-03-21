//
//  ConnexionHelper.swift
//  My Car
//
//  Created by Axel Lefaux on 03/03/2018.
//  Copyright © 2018 ITomorrow. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit

class ConnexionHelper {
    static let helper = ConnexionHelper()
    
    func logInWithGoogle(authentification: GIDAuthentication){
        let credential = GoogleAuthProvider.credential(withIDToken: authentification.idToken, accessToken: authentification.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                print(user?.email ?? "User instance is nil")
                print(user?.displayName ?? "User instance is nil")
                
                self.saveUserData(uid: user!.uid, displayName: user!.displayName!, email: user!.email!)
            }
        }
    }
    
    func logInWithFacebook(){
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            } else {
                print(user?.email ?? "User instance is nil")
                print(user?.displayName ?? "User instance is nil")

                self.saveUserData(uid: user!.uid, displayName: user!.displayName!, email: user!.email!)
            }
        }
    }
    
    func logInWithEmail(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (userBase, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else if let user = userBase {
                print(user.displayName ?? "User instance is nil")
                print(user)
            }
        }
    }
    
    func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidMotDePasse(motDePasseStr: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{6,}$")
        return passwordTest.evaluate(with: motDePasseStr)
    }
    
    func saveUserData(uid: String, displayName: String, email: String) {
        print("saveUserData")
        
        let newUser = Database.database().reference().child("users").child(uid)
        newUser.setValue(["uidExterne":"\(uid)","displayName":"\(displayName)","email":"\(email)"])
        
        switchToVoituresViewController()
    }
    
    func switchToVoituresViewController() {
        print("View change")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationViewController
    }
    
    func switchToLoginViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationViewController
    }
}
