//
//  LoginViewController.swift
//  My Car
//
//  Created by Axel Lefaux on 03/03/2018.
//  Copyright © 2018 ITomorrow. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate,
UITextFieldDelegate {
    @IBOutlet weak var loginByFacebookButton: FBSDKLoginButton!
    @IBOutlet weak var loginByEmailButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loginByEmailButton.layer.borderWidth = 2.0
        loginByEmailButton.layer.borderColor = UIColor.white.cgColor
        
        GIDSignIn.sharedInstance().clientID = "1048697655603-oocu0v1fm938mudemaj86rjgno666vph.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        if Auth.auth().currentUser != nil {
            ConnexionHelper.helper.switchToVoituresViewController()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print(error!.localizedDescription)
            
            return
        }
        
        print(user.authentication)
        // Log with Google
        ConnexionHelper.helper.logInWithGoogle(authentification: user.authentication)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                if (result?.isCancelled)! {
                    return
                }
                
                if let fbLoginResult = result {
                    if fbLoginResult.grantedPermissions.contains("email") {
                        if((FBSDKAccessToken.current()) != nil){
                            ConnexionHelper.helper.logInWithFacebook()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func logInWithEmail(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if( email != nil && password != nil) {
            ConnexionHelper.helper.logInWithEmail(email: email!, password: password!)
        } else {
            print("Champs vide login with email")
            
            let alert = UIAlertController(title: "Connexion impossible", message: "Les champs doivent être remplis pour la connexion.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            })
        }
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
