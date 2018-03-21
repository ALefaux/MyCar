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
    @IBOutlet weak var buttonAjouter: UIButton!
    @IBOutlet weak var buttonModifier: UIButton!
    
    var activeField: UITextField?
    var imagePicker = UIImagePickerController()
    var imageVoitureHasChange: Bool = false
    var voiture: Voiture? = nil
    
    @IBAction func chooseImageButtonClick() {
        print("Image picker")
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if voiture != nil {
            initializeView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddVoitureViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddVoitureViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        chooseImageButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }
    
    public func initializeVoiture(voiture: Voiture) {
        self.voiture = voiture
    }
    
    public func initializeView() {
        print(voiture!)
        print("Url voiture : \(voiture!.image)")
        
        self.nomTextField.text = self.voiture!.nom
        self.marqueTextField.text = self.voiture!.marque
        self.modeleTextField.text = self.voiture!.modele
        self.plaqueTextField.text = self.voiture!.plaque
        
        buttonAjouter.isHidden = true
        buttonModifier.isHidden = false
        
        if let url = URL(string: voiture!.image) {
            if let data = try? Data(contentsOf: url) {
                let uiImage = UIImage(data: data)
                
                chooseImageButton.setImage(uiImage, for: .normal)
            } else {
                print("Erreur initializeView ajouter voiture")
            }
        }
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
    
    @IBAction func modifierVoiture(_ sender: Any) {
        print("Modifier voiture")
        
        let nomVoiture: String? = nomTextField.text
        let marqueVoiture: String? = marqueTextField.text
        let modeleVoiture: String? = modeleTextField.text
        let plaqueVoiture: String? = plaqueTextField.text
        
        if !Helper.instance.stringIsNulOrEmpty(string: nomVoiture)
            && !Helper.instance.stringIsNulOrEmpty(string: marqueVoiture)
            && !Helper.instance.stringIsNulOrEmpty(string: modeleVoiture)
            && !Helper.instance.stringIsNulOrEmpty(string: plaqueVoiture) {
            
            if imageVoitureHasChange {
                self.uploadImage(image: chooseImageButton.currentImage!, nom: nomVoiture!, marque: marqueVoiture!, modele: modeleVoiture!, plaque: plaqueVoiture!, isModification: true)
            } else {
                //self.enregistrerVoiture(nom: nomVoiture!, marque: marqueVoiture!, modele: modeleVoiture!, plaque: plaqueVoiture!, url: nil)
                print("Enregistrement de la voiture")
                self.modifierVoiture(nom: nomVoiture!, marque: marqueVoiture!, modele: modeleVoiture!, plaque: plaqueVoiture!, url: voiture?.image)
            }
        } else {
            let alert = UIAlertController(title: "Ajout impossible", message: "Les champs doivent tous être remplis.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadImage(image: UIImage, nom: String, marque: String, modele: String, plaque: String, isModification: Bool = false) {
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
                            
                            if !isModification {
                                self.enregistrerVoiture(nom: nom, marque: marque, modele: modele, plaque: plaque, url: urlImage)
                            } else {
                                // Update
                                self.modifierVoiture(nom: nom, marque: marque, modele: modele, plaque: plaque, url: urlImage)
                            }
                        } else if let urls = metadata.downloadURLs {
                            let urlImage = urls[0].absoluteString
                            
                            if !isModification {
                                self.enregistrerVoiture(nom: nom, marque: marque, modele: modele, plaque: plaque, url: urlImage)
                            } else {
                                // Update
                                self.modifierVoiture(nom: nom, marque: marque, modele: modele, plaque: plaque, url: urlImage)
                            }
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
    
    func modifierVoiture(nom: String, marque: String, modele: String, plaque: String, url: String?) {
        print("modifierVoiture")
        Database.database().reference().child("Voitures").child(voiture!.id).updateChildValues(["image":"\(url ?? "")", "nom":"\(nom)", "marque":"\(marque)", "modele":"\(modele)", "plaque":"\(plaque)"])
        
        // Retour en arriere
        let navigationViewController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        navigationViewController.popViewController(animated: true)
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
