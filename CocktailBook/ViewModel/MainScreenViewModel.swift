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
        
        favReceiver.sink { cocktailModel in
            for i in 0 ..< self.arrCocktailsMain.count {
                if cocktailModel.id == self.arrCocktailsMain[i].id{
                    self.arrCocktailsMain[i].setSelection(isSelect: cocktailModel.selected)
                    break
                }
            }
            for i in 0 ..< self.arrCocktails.count {
                if cocktailModel.id == self.arrCocktails[i].id{
                    self.arrCocktails[i].setSelection(isSelect: cocktailModel.selected)
                    break
                }
            }
        }.store(in: &cancellables)
        
        
        
        $cocktailType
            .receive(on: DispatchQueue.main)
            .sink { index in
            switch index {
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
        .store(in: &cancellables)
    }
    
    
    func loadData(){
        api.cocktailsPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("load completion")
                switch completion {
                case .failure(.unavailable) :
                    self.arrCocktails = []
                default:
                    print("--<finished>--")
                }
            } receiveValue: { data in
                let jsonDecoder = JSONDecoder()
                do{
                    var responseModel = try jsonDecoder.decode([CocktailModel].self, from: data)
                    for i in 0 ..< FavStore.shared.favIDs.count {
                        let favID = FavStore.shared.favIDs[i]
                        for j in 0 ..< responseModel.count {
                            if responseModel[j].id == favID {
                                responseModel[j].setSelection(isSelect: true)
                                break
                            }
                        }
                    }
                    
                    self.arrCocktailsMain = responseModel.sorted { $0.name! < $1.name! }
                    
                    
                    let selected = self.arrCocktailsMain.filter{$0.selected == true}.sorted { $0.name! < $1.name! }
                    let nonSelected = self.arrCocktailsMain.filter{$0.selected == false}.sorted { $0.name! < $1.name! }
                    self.arrCocktails = selected + nonSelected
                    
                }catch {
                    self.arrCocktails = []
                }
                
            }
            .store(in: &cancellables)

    }
    func setSelection(cocktailModel:CocktailModel){
        for i in 0 ..< self.arrCocktailsMain.count {
            if cocktailModel.id == self.arrCocktailsMain[i].id{
                self.arrCocktailsMain[i].setSelection(isSelect: !cocktailModel.selected)
                break
            }
        }
        for i in 0 ..< self.arrCocktails.count {
            if cocktailModel.id == self.arrCocktails[i].id{
                self.arrCocktails[i].setSelection(isSelect: !cocktailModel.selected)
                break
            }
        }
        
    }

}
