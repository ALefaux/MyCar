//
//  InscriptionViewController.swift
//  My Car
//
//  Created by Axel Lefaux on 10/03/2018.
//  Copyright © 2018 ITomorrow. All rights reserved.
//

import UIKit
import FirebaseAuth

class InscriptionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confPasswordTextField: UITextField!
    @IBOutlet weak var validerButton: UIButton!
    @IBOutlet weak var annulerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        validerButton.layer.borderWidth = 2.0
        validerButton.layer.borderColor = UIColor.white.cgColor
        
        annulerButton.layer.borderWidth = 2.0
        annulerButton.layer.borderColor = UIColor.white.cgColor
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            confPasswordTextField.becomeFirstResponder()
        } else if textField == self.confPasswordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validerInscription(_ sender: Any) {
        // Vérifier le mot de passe.
        if let password = passwordTextField.text,
            ConnexionHelper.helper.isValidMotDePasse(motDePasseStr: password){
            
            // Vérifier si la confirmation de mot de passe et le mot de passe sont identiques.
            if let confPassword = confPasswordTextField.text,
                confPassword == password {
                
                // Vérier l'adresse mail.
                if let email = emailTextField.text,
                    ConnexionHelper.helper.isValidEmail(testStr: email) {
                    
                    // Enregistrer l'utilisateur
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else {
                            ConnexionHelper.helper.saveUserData(uid: email, displayName: email, email: email)
                        }
                    })
                } else {
                    let alert = UIAlertController(title: "E-mail non valide", message: "L'adresse e-mail saisie n'est pas conforme.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: {
                        self.passwordTextField.text = ""
                        self.confPasswordTextField.text = ""
                    })
                }
            } else {
                let alert = UIAlertController(title: "Mot de passe non valide", message: "Les mots de passe ne sont pas valides.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: {
                    self.passwordTextField.text = ""
                    self.confPasswordTextField.text = ""
                })
            }
        } else {
            let alert = UIAlertController(title: "Mot de passe non valide", message: "Le mot de passe doit contenir au moins une majuscule, une minuscule, un chiffre et doit avoir 6 caractères minimum.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: {
                self.passwordTextField.text = ""
                self.confPasswordTextField.text = ""
            })
        }
    }
    
    @IBAction func annulerInscription(_ sender: Any) {
        print("Annuler")
        emailTextField.text = ""
        passwordTextField.text = ""
        confPasswordTextField.text = ""
        
        // Redirection vers la vue de connexion
        ConnexionHelper.helper.switchToLoginViewController()
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
