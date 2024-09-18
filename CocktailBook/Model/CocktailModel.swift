//
//  CocktailModel.swift
//  CocktailBook
//
//  Created by Administrator on 05/09/24.
//

import Foundation
struct CocktailModel : Codable {
    let id : String?
    let name : String?
    let type : String?
    let shortDescription : String?
    let longDescription : String?
    let preparationMinutes : Int?
    let imageName : String?
    let ingredients : [String]
    var selected:Bool
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case type = "type"
        case shortDescription = "shortDescription"
        case longDescription = "longDescription"
        case preparationMinutes = "preparationMinutes"
        case imageName = "imageName"
        case ingredients = "ingredients"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        shortDescription = try values.decodeIfPresent(String.self, forKey: .shortDescription)
        longDescription = try values.decodeIfPresent(String.self, forKey: .longDescription)
        preparationMinutes = try values.decodeIfPresent(Int.self, forKey: .preparationMinutes)
        imageName = try values.decodeIfPresent(String.self, forKey: .imageName)
        ingredients = try values.decodeIfPresent([String].self, forKey: .ingredients) ?? [String]()
        selected = false
    }
    mutating func setSelection(isSelect:Bool){
        self.selected = isSelect
        if (isSelect){
            if (!FavStore.shared.favIDs.contains{$0 == self.id})
            { 
                FavStore.shared.favIDs.append(self.id ?? "-")
            }
        }else{
            FavStore.shared.favIDs.removeAll{$0 == self.id}
        }
    }
}
