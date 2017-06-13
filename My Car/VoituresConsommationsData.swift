//
//  VoituresConsommationsData.swift
//  My Car
//
//  Created by Axel Lefaux on 21/05/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import Foundation

class VoituresConsommationsData {
    
    var listeVoitures: [Voiture] = []
    
    init() {
        let voiture1 = Voiture(p_id: 0, p_nom: "Titine", p_marque: "Renault", p_modele: "Laguna", p_plaque: "AV-777-VT", p_image: "VoitureNoire.png")
        voiture1.addConsommation(consommation: (Consommation(p_id: 0, p_date: "21/05/2017",p_lieu: "Carrefour Lomme", p_prix: 1.34, p_litres: 54, p_prixLitre: 72.38, p_distanceGeneral: 59321, p_distancePartielle: 21000, p_consommationMoyenne: 4.2, p_distanceParcourue: 596, p_vitesseMoyenne: 54.6, p_infoComplementaires: "", p_carburantUtilise: 45.0)))
        voiture1.addConsommation(consommation: (Consommation(p_id: 1, p_date: "22/05/2017", p_lieu: "Cora Anould", p_prix: 1.29, p_litres: 18, p_prixLitre: 23.22, p_distanceGeneral: 34593, p_distancePartielle: 12990, p_consommationMoyenne: 5.4, p_distanceParcourue: 345, p_vitesseMoyenne: 60.9, p_infoComplementaires: "", p_carburantUtilise: 34.2)))
        listeVoitures.append(voiture1)
        
        let voiture2 = Voiture(p_id: 1, p_nom: "Tuture", p_marque: "Audi", p_modele: "R8", p_plaque: "DR-384-ZL", p_image: "VoitureRouge.png")
        voiture1.addConsommation(consommation: (Consommation(p_id: 0, p_date: "21/05/2017",p_lieu: "Carrefour Lomme", p_prix: 1.34, p_litres: 54, p_prixLitre: 72.38, p_distanceGeneral: 59321, p_distancePartielle: 21000, p_consommationMoyenne: 4.2, p_distanceParcourue: 596, p_vitesseMoyenne: 54.6, p_infoComplementaires: "", p_carburantUtilise: 45.0)))
        listeVoitures.append(voiture2)
    }
    
    public func GetVoitures() -> [Voiture] {
        return listeVoitures;
    }
    
}
