//
//  AddVoitureViewController.swift
//  My Car
//
//  Created by Axel Lefaux on 05/06/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddVoitureViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var mainViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var marqueTextField: UITextField!
    @IBOutlet weak var modeleTextField: UITextField!
    @IBOutlet weak var plaqueTextField: UITextField!
    @IBOutlet var chooseImageButton: UIButton!
    
    var activeField: UITextField?
    var imagePicker = UIImagePickerController()
    
    @IBAction func chooseImageButtonClick() {
        print("Image picker")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(AddVoitureViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(AddVoitureViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
        let idVoiture: Int = MyCarAPI.sharedInstance.getNbVoitures()
        let nomVoiture: String = nomTextField.text!
        let marqueVoiture: String = marqueTextField.text!
        let modeleVoiture: String = modeleTextField.text!
        let plaqueVoiture: String = plaqueTextField.text!
        
        MyCarAPI.sharedInstance.addVoiture(voiture: Voiture(p_id: idVoiture, p_nom: nomVoiture, p_marque: marqueVoiture, p_modele: modeleVoiture, p_plaque: plaqueVoiture, p_image: "VoitureNoire.png"))
        
        self.viewDidDisappear(true)
    }

}

extension AddVoitureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Did finish picking photo")
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            chooseImageButton.setImage(image, for: UIControlState.normal)
            print("OriginalImage")
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            chooseImageButton.setImage(image, for: UIControlState.normal)
            print("EditedImage")
        } else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
