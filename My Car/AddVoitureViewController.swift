//
//  AddVoitureViewController.swift
//  My Car
//
//  Created by Axel Lefaux on 05/06/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import UIKit
import MobileCoreServices
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddVoitureViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var marqueTextField: UITextField!
    @IBOutlet weak var modeleTextField: UITextField!
    @IBOutlet weak var plaqueTextField: UITextField!
    @IBOutlet var chooseImageButton: UIButton!
    
    var activeField: UITextField?
    var imagePicker = UIImagePickerController()
    var imageVoitureHasChange : Bool = false
    
    @IBAction func chooseImageButtonClick() {
        print("Image picker")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddVoitureViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddVoitureViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.nomTextField:
            self.marqueTextField.becomeFirstResponder()
        case self.marqueTextField:
            self.modeleTextField.becomeFirstResponder()
        case self.modeleTextField:
            self.plaqueTextField.becomeFirstResponder()
        case self.plaqueTextField:
            self.plaqueTextField.resignFirstResponder()
        default:
            self.nomTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
            //The view will scroll up only for the following textfield
            
            if activeField == marqueTextField || activeField == modeleTextField || activeField == plaqueTextField || activeField == nomTextField {
                
                UIView.animate(withDuration: 0.8) {
                    self.mainViewBottomConstraint.constant = keyboardFrame.size.height
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.8) {
            self.mainViewBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func ajouterVoiture(_ sender: Any) {
        let nomVoiture: String? = nomTextField.text
        let marqueVoiture: String? = marqueTextField.text
        let modeleVoiture: String? = modeleTextField.text
        let plaqueVoiture: String? = plaqueTextField.text
        
        if !Helper.instance.stringIsNulOrEmpty(string: nomVoiture)
            && !Helper.instance.stringIsNulOrEmpty(string: marqueVoiture)
            && !Helper.instance.stringIsNulOrEmpty(string: modeleVoiture)
            && !Helper.instance.stringIsNulOrEmpty(string: plaqueVoiture) {
            
            if imageVoitureHasChange {
//                self.uploadImage(image: chooseImageButton.currentImage!)
                self.uploadImage(image: chooseImageButton.currentImage!, nom: nomVoiture!, marque: marqueVoiture!, modele: modeleVoiture!, plaque: plaqueVoiture!)
            } else {
                self.enregistrerVoiture(nom: nomVoiture!, marque: marqueVoiture!, modele: modeleVoiture!, plaque: plaqueVoiture!, url: nil)
            }
        } else {
            let alert = UIAlertController(title: "Ajout impossible", message: "Les champs doivent tous être remplis.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadImage(image: UIImage, nom: String, marque: String, modele: String, plaque: String) {
        if Auth.auth().currentUser != nil {
            if let data = UIImageJPEGRepresentation(image, 0.1) {
                let filepath = "\(Auth.auth().currentUser!.uid)/\(NSDate.timeIntervalSinceReferenceDate)"
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                Storage.storage().reference().child(filepath).putData(data, metadata: metadata, completion: { (metaData, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    if let metadata = metaData {
                        if let url = metadata.downloadURL() {
                            let urlImage = url.absoluteString
                            self.enregistrerVoiture(nom: nom, marque: marque, modele: modele, plaque: plaque, url: urlImage)
                        } else if let urls = metadata.downloadURLs {
                            let urlImage = urls[0].absoluteString
                            self.enregistrerVoiture(nom: nom, marque: marque, modele: modele, plaque: plaque, url: urlImage)
                        }
                        
                        ConnexionHelper.helper.switchToVoituresViewController()
                    }
                })
            }
        } else {
            print("Pas connecté")
        }
    }
    
    func enregistrerVoiture(nom: String, marque: String, modele: String, plaque: String, url: String?) {
        let voiture = Database.database().reference().child("Voitures").childByAutoId()
        voiture.setValue(["image":"\(url ?? "")", "nom":"\(nom)", "marque":"\(marque)", "modele":"\(modele)", "plaque":"\(plaque)"])
    }
}

extension AddVoitureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Did finish picking photo")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chooseImageButton.setImage(image, for: UIControlState.normal)
            
            imageVoitureHasChange = true
            print("OriginalImage")
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            chooseImageButton.setImage(image, for: UIControlState.normal)
            
            imageVoitureHasChange = true
            print("EditedImage")
        } else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
