//
//  PersistencyManager.swift
//  My Car
//
//  Created by Axel Lefaux on 04/06/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    public var voitures = [Voiture]()
    
    override init() {
        let voiture1 = Voiture(p_id: 0, p_nom: "Titine", p_marque: "Renault", p_modele: "Laguna", p_plaque: "AV-777-VT", p_image: "VoitureNoire.png")
        let voiture2 = Voiture(p_id: 1, p_nom: "Tuture", p_marque: "Audi", p_modele: "R8", p_plaque: "DR-384-ZL", p_image: "VoitureRouge.png")
        
        voitures = [voiture1, voiture2]
    }
    
    func getVoitures() -> [Voiture] {
        return voitures
    }
    
    func getNbVoitures() -> Int {
        return voitures.count
    }
    
    func addVoiture(voiture: Voiture) {
        voitures.append(voiture)
    }
    
    func deleteVoitureAtIndex(index: Int) {
        voitures.remove(at: index)
    }
}
