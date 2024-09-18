//
//  MainScreenView.swift
//  CocktailBook
//
//  Created by Administrator on 13/09/24.
//

import SwiftUI
import Combine
struct MainScreenView: View {
    @ObservedObject var vm = MainScreenViewModel()
    
    var body: some View {
        NavigationView(content: {
            
            VStack {
                segment
                List(vm.arrCocktails, id:\.id) {[self] obj in
                    let detailsViewModel = MainScreenDetailViewModel(cocktailModel: obj, favPublisher: vm.favReceiver)
                    NavigationLink(destination: MainScreenDetailView(vm: detailsViewModel)) {
                        cell(data: obj)
                    }
                }
                .navigationBarTitle(Text(titleText()))
            }
            
        })
        .onAppear(perform: {
            vm.loadData()
        })
    }
    var segment:some View {
        Picker("Alcohal Type", selection: $vm.cocktailType) {
                        Text("All").tag(0)
                        Text("Alcoholic").tag(1)
                        Text("Non-Alcoholic").tag(2)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.leading, .trailing], 20)
    }
    
    func titleText()->String {
        return vm.cocktailType == 0 ? "All Cocktails": (vm.cocktailType == 1 ? "Alcoholic" : "Non-Alcoholic")
    }
    func cell(data:CocktailModel) -> some View {
        VStack(alignment:.leading){
            HStack {
                Text(data.name ?? "-").font(.title)
                Spacer()
                Button(action: {
                    
                }, label: {
                    Image(systemName: data.selected ? "heart.fill" : "heart")
                })
                .frame(width: 35, height: 35)
                .onTapGesture {
                    vm.setSelection(cocktailModel: data)
                }
            }
            Text(data.shortDescription ?? "-").font(.subheadline)
        }
    }
}

#Preview {
    MainScreenView()
}
