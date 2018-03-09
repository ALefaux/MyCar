//
//  ViewController.swift
//  My Car
//
//  Created by Axel Lefaux on 22/04/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import UIKit
import FirebaseAuth

class VoituresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableViewVoitures: UITableView!
    
    var listeVoitures: [Voiture] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //listeVoitures = MyCarAPI.sharedInstance.getVoitures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listeVoitures = MyCarAPI.sharedInstance.getVoitures()
        tableViewVoitures.reloadData()
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
        cell.imageVoiture.image = UIImage(named:self.listeVoitures[indexPath.row].image)
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let logInViewController = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = logInViewController
        } catch let signOutError as NSError {
            // Erreur de deconnexion
            print("Error sign out: \(signOutError)")
        }
    }
}

