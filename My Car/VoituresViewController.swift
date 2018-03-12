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
//        self.listeVoitures = MyCarAPI.sharedInstance.getVoitures()
        self.observeVoiture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

