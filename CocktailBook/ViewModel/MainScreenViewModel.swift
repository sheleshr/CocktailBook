//
//  MainScreenViewModel.swift
//  CocktailBook
//
//  Created by Administrator on 13/09/24.
//

import Foundation
import SwiftUI
import Combine

class MainScreenViewModel : ObservableObject{
    let api: FakeCocktailsAPI
    private var cancellables = Set<AnyCancellable>()
    
    @Published var arrCocktailsMain = [CocktailModel]()
    @Published var arrCocktails = [CocktailModel]()
    
    @Published var cocktailType = 0
    
    var favReceiver = PassthroughSubject<CocktailModel, Never>()
    
    init(api:FakeCocktailsAPI = FakeCocktailsAPI()) {
        self.api = api
        
        favReceiver.sink {[unowned self] cocktailModel in
            self.setCocktailType(idx: self.cocktailType)
            self.objectWillChange.send()

        }.store(in: &cancellables)
        
        
        
        $cocktailType
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] index in
                self.setCocktailType(idx: index)
        }
        .store(in: &cancellables)
    }
    func setCocktailType(idx:Int){
        switch idx {
        case 0:
            let selected = self.arrCocktailsMain.filter{$0.selected == true}.sorted { $0.name! < $1.name! }
            let nonSelected = self.arrCocktailsMain.filter{$0.selected == false}.sorted { $0.name! < $1.name! }
            self.arrCocktails = selected + nonSelected
            
        case 1:
            let arrAlcoholic = self.arrCocktailsMain.filter{$0.type == "alcoholic"}
            let selected = arrAlcoholic.filter{$0.selected == true}.sorted { $0.name! < $1.name! }
            let nonSelected = arrAlcoholic.filter{$0.selected == false}.sorted { $0.name! < $1.name! }
            self.arrCocktails = selected + nonSelected
            
        default:
            let arrAlcoholic = self.arrCocktailsMain.filter{$0.type == "non-alcoholic"}
            let selected = arrAlcoholic.filter{$0.selected == true}.sorted { $0.name! < $1.name! }
            let nonSelected = arrAlcoholic.filter{$0.selected == false}.sorted { $0.name! < $1.name! }
            self.arrCocktails = selected + nonSelected
        }
    }
    
    func loadData(){
        
        api.cocktailsPublisher
            .decode(type: [CocktailModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("load completion")
                switch completion {
                case .failure(_) :
                    self.arrCocktails = []
                default:
                    print("--<finished>--")
                }
            } receiveValue: {[unowned self] responseModel in
                
                self.arrCocktailsMain = responseModel.sorted { $0.name! < $1.name! }
                
                let selected = self.arrCocktailsMain.filter{$0.selected == true}.sorted { $0.name! < $1.name! }
                let nonSelected = self.arrCocktailsMain.filter{$0.selected == false}.sorted { $0.name! < $1.name! }
                self.arrCocktails = selected + nonSelected
            }
            .store(in: &cancellables)
   
    }
    func setSelection(cocktailModel:CocktailModel){
        cocktailModel.setSelection(isSelect: !cocktailModel.selected)
        
        let selected = self.arrCocktailsMain.filter{$0.selected == true}.sorted { $0.name! < $1.name! }
        let nonSelected = self.arrCocktailsMain.filter{$0.selected == false}.sorted { $0.name! < $1.name! }
        self.arrCocktails = selected + nonSelected
        
        self.objectWillChange.send()
        
    }

}
