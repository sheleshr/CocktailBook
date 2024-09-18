//
//  FavStore.swift
//  CocktailBook
//
//  Created by Administrator on 18/09/24.
//

import Foundation

class FavStore {
    private var keyUserDefaults = "__FAV_ID_STORE__"
    static var shared = FavStore()
    var favIDs = [String]()
    private init(){
        
    }
    func loadFavIDs(){
        if let uDefaults = UserDefaults.standard.value(forKey: keyUserDefaults) as? [String]{
            favIDs = uDefaults
        }else{
            favIDs = [String]()
        }
    }
    func saveFavIDs(){
        UserDefaults.standard.setValue(favIDs, forKey: keyUserDefaults)
        UserDefaults.standard.synchronize()
    }
    
    
}
