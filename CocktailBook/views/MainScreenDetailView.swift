//
//  MainScreenDetailView.swift
//  CocktailBook
//
//  Created by Administrator on 15/09/24.
//

import SwiftUI

struct MainScreenDetailView: View {
    @ObservedObject var vm: MainScreenDetailViewModel
    var body: some View {
        Form{
            VStack(alignment:.leading){
                cocktailName
                preprationMin
                cocktailImage
                cocktailLongDescription
                ingrediants
            
            }
        }
        .navigationBarItems(trailing: Button(action: {
                            
                            vm.favClicked()
                        }, label: {
                            Image(systemName: vm.cocktailModel.selected ? "heart.fill" : "heart")
                        })
                        .frame(width: 35, height: 35)
                    )
        
    }
    var cocktailName:some View {
        Text(vm.cocktailModel.name ?? "-")
            .font(.largeTitle)
    }
    var preprationMin: some View{
        HStack{
            Image("clock")
            Text("\(vm.cocktailModel.preparationMinutes ?? 0) minutes")
        }
    }
    var cocktailImage:some View{
        Image(vm.cocktailModel.imageName ?? "")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    var cocktailLongDescription:some View{
        Text(vm.cocktailModel.longDescription ?? "-")
    }
    var ingrediants:some View{
        VStack(alignment:.leading){
            Text("Ingrediants")
            
            List(vm.cocktailModel.ingredients, id: \.self) { ingrediant in
                HStack{
                    Image(systemName: "arrow.forward")
                    Text(ingrediant)
                }
            }
            
        }
    }
}

//#Preview {
//    MainScreenDetailView()
//}
