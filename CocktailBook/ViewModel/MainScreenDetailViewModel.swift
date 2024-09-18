//
//  MainScreenDetailViewModel.swift
//  CocktailBook
//
//  Created by Administrator on 15/09/24.
//

import Foundation
import SwiftUI
import Combine

class MainScreenDetailViewModel: ObservableObject {
    @Published var cocktailModel:CocktailModel
    var favPublisher : PassthroughSubject<CocktailModel, Never>
    
    init(cocktailModel: CocktailModel, favPublisher : PassthroughSubject<CocktailModel, Never>) {
        self.cocktailModel = cocktailModel
        self.favPublisher = favPublisher
    }
    func favClicked() {
        cocktailModel.setSelection(isSelect: !cocktailModel.selected)
        favPublisher.send(cocktailModel)
    }
}
