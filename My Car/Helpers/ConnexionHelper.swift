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

class ConnexionHelper {
    static let helper = ConnexionHelper()
    
    func logInWithGoogle(authentification: GIDAuthentication){
        let credential = GoogleAuthProvider.credential(withIDToken: authentification.idToken, accessToken: authentification.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print(user?.email ?? "User instance is nil")
                print(user?.displayName ?? "User instance is nil")
                
                let newUser = Database.database().reference().child("utilisateurs").child(user!.uid)
                newUser.setValue(["nom":"\(user!.displayName!)","id":"\(user!.uid)"])
                
                self.switchToNavigationViewController()
            }
        }
    }
    
    func logInWithEmail(){
        Auth.auth().signIn(withEmail: "", password: "") { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print(user!.displayName)
                print(user!)
                
                self.saveUserData(uidExterne: user!.uid, displayName: user!.displayName!, email: user!.email!)
            }
        }
    }
    
    func saveUserData(uidExterne: String, displayName: String, email: String) {
        print("saveUserData")
        
        let newUser = Database.database().reference().child("users").childByAutoId()
        newUser.setValue(["uidExterne":"\(uidExterne)","displayName":"\(displayName)","email":"\(email)"])
        
        switchToNavigationViewController()
    }
    
    func switchToNavigationViewController() {
        print("View change")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationViewController = storyboard.instantiateViewController(withIdentifier: "NavigationViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationViewController
    }
}
