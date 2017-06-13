//
//  MyCarAPI.swift
//  My Car
//
//  Created by Axel Lefaux on 04/06/2017.
//  Copyright © 2017 ITomorrow. All rights reserved.
//

import UIKit

class MyCarAPI: NSObject {
    private let persistencyManager:PersistencyManager
    
    override init(){
        persistencyManager = PersistencyManager()
        
        super.init()
    }
    
    class var sharedInstance: MyCarAPI {
        struct Singleton {
            static let instance = MyCarAPI()
        }
        return Singleton.instance
    }
    
    func getVoitures() -> [Voiture] {
        return persistencyManager.getVoitures()
    }
    
    func getNbVoitures() -> Int {
        return persistencyManager.getNbVoitures()
    }
    
    func addVoiture(voiture: Voiture){
        persistencyManager.addVoiture(voiture: voiture)
    }
    
    func deleteVoiture(index: Int){
        persistencyManager.deleteVoitureAtIndex(index: index)
    }
}
