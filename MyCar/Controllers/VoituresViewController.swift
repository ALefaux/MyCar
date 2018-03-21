//
//  ViewController.swift
//  My Car
//
//  Created by Axel Lefaux on 22/04/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class VoituresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableViewVoitures: UITableView!
    
    var listeVoitures: [Voiture] = []
    var refVoitures: DatabaseReference = Database.database().reference().child("Voitures")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func observeVoiture() {
        if Auth.auth().currentUser != nil {
            refVoitures.observe(.childAdded, with: { snapshot in
                if !snapshot.exists() {
                    return
                }
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    var url = dict["image"] as? String
                    let nom = dict["nom"] as? String
                    let marque = dict["marque"] as? String
                    let modele = dict["modele"] as? String
                    let plaque = dict["plaque"] as? String
                    var isUrl = true
                    
                    if Helper.instance.stringIsNulOrEmpty(string: url) {
                        url = "VoitureNoire"
                        isUrl = false
                    }
                    
                    self.listeVoitures.append(Voiture(p_id: "\(snapshot.key)", p_nom: nom!, p_marque: marque!, p_modele: modele!, p_plaque: plaque!, p_image: url!, p_isUrl: isUrl))
                    
                    self.tableViewVoitures.reloadData()
                }
            })
        } else {
            ConnexionHelper.helper.switchToLoginViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        afficherVoitures()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func afficherVoitures() {
        listeVoitures = []
        self.observeVoiture()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeVoitures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VoitureTableViewCell = self.tableViewVoitures.dequeueReusableCell(withIdentifier: "VoitureCell") as! VoitureTableViewCell
        
        if self.listeVoitures[indexPath.row].isUrl {
            let data = try? Data(contentsOf: URL(string: self.listeVoitures[indexPath.row].image)!)
            cell.imageVoiture.image = UIImage(data: data!)
        } else {
            cell.imageVoiture.image = UIImage(named:self.listeVoitures[indexPath.row].image)
        }
        
        cell.labelMarqueModelVoiture.text = self.listeVoitures[indexPath.row].marque + " " + self.listeVoitures[indexPath.row].modele
        cell.labelNomVoiture.text = self.listeVoitures[indexPath.row].nom
        cell.labelPlaqueVoiture.text = self.listeVoitures[indexPath.row].plaque
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Doit afficher le détail de la voiture
        print("Did select row at \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let modifier = UITableViewRowAction(style: .normal, title: "Modifier") { (action, index) in
            print("Item modifier à l'index \(index)")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationViewController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
            let ajouterVoitureViewController = storyboard.instantiateViewController(withIdentifier: "AjouterVoitureViewController") as? AddVoitureViewController
            ajouterVoitureViewController?.initializeVoiture(voiture: self.listeVoitures[index.row])
            
            navigationViewController.pushViewController(ajouterVoitureViewController!, animated: true)
        }
        modifier.backgroundColor = UIColor.blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Supprimer") { (action, index) in
            print("Item supprimer à l'index \(index)")
            
            let alert = UIAlertController(title: "Confirmation", message: "Êtes vous sur de vouloir supprimer la voiture ?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action) in
                print("Suppression voiture")
                
                let idVoiture = self.listeVoitures[index.row].id
                
                self.refVoitures.child(idVoiture).removeValue { error, _ in
                    if error != nil {
                        print("error \(error!)")
                    } else {
                        self.showToast(message: "Voiture  supprimée.")
                        
                        self.listeVoitures.remove(at: index.row)
                        self.tableViewVoitures.reloadData()
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Non", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = UIColor.red
        
        return [delete, modifier]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            // Deconnexion
            try Auth.auth().signOut()
            
            // Redirection vers la vue de connexion
            ConnexionHelper.helper.switchToLoginViewController()
        } catch let signOutError as NSError {
            // Erreur de deconnexion
            print("Error sign out: \(signOutError)")
        }
    }
}
