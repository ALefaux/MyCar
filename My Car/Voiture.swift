//
//  Voiture.swift
//  My Car
//
//  Created by Axel Lefaux on 21/05/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import Foundation

class Voiture {
    var id: String
    var nom: String
    var marque: String
    var modele: String
    var plaque: String
    var image: String
    var isUrl: Bool
    
    var listeConsommations = [Consommation]()
    
    init(p_id:String, p_nom:String, p_marque:String, p_modele:String, p_plaque:String, p_image: String, p_isUrl: Bool) {
        id = p_id
        nom = p_nom
        marque = p_marque
        modele = p_modele
        plaque = p_plaque
        image = p_image
        isUrl = p_isUrl
    }
    
    func getConsommations() -> [Consommation]{
        return listeConsommations
    }
    
    func addConsommation(consommation: Consommation){
        listeConsommations.append(consommation)
    }
    
    func removeConsommation(index: Int){
        listeConsommations.remove(at: index)
    }
}
