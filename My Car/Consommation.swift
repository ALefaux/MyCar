//
//  Consommation.swift
//  My Car
//
//  Created by Axel Lefaux on 21/05/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import Foundation

class Consommation {
    var id: Int
    var date: String
    var lieu: String
    
    var prix: Decimal
    var litres: Decimal
    var prixLitre: Decimal
    
    var distanceGenerale: Decimal
    var distancePartielle: Decimal
    var consommationMoyenne: Decimal
    var distanceParcourue: Decimal
    var vitesseMoyenne: Decimal
    var infoComplementaires: String
    var carburantUtilise: Decimal
    
    init(p_id:Int, p_date: String, p_lieu: String, p_prix: Decimal, p_litres:Decimal, p_prixLitre: Decimal, p_distanceGeneral: Decimal, p_distancePartielle: Decimal, p_consommationMoyenne: Decimal, p_distanceParcourue: Decimal, p_vitesseMoyenne: Decimal, p_infoComplementaires: String, p_carburantUtilise: Decimal) {
        id = p_id
        date = p_date
        lieu = p_lieu
        
        prix = p_prix
        litres = p_litres
        prixLitre = p_prixLitre
        
        distanceGenerale = p_distanceGeneral
        distancePartielle = p_distancePartielle
        consommationMoyenne = p_consommationMoyenne
        distanceParcourue = p_distanceParcourue
        vitesseMoyenne = p_vitesseMoyenne
        infoComplementaires = p_infoComplementaires
        carburantUtilise = p_carburantUtilise
    }
}
