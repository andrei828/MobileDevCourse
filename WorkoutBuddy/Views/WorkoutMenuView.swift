//
//  WorkoutMenuView.swift
//  UI
//
//  Created by user196345 on 5/19/22.
//

import SwiftUI

struct WorkoutMenuView: View {
    var categories: [WorkoutCategory] = []
    var dm = DataManagerClass()
    
    init(){
        categories = dm.getCategories()
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(categories) {category in
                    CategoryRow(category: category)
                }
            }
            .navigationBarTitle(Text("Workout"))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CategoryRow: View {
   
    let category: WorkoutCategory
    
    var body: some View {
        NavigationLink(destination: ExerciseListView(CategoryId: category.id)){

            HStack{
                Image(category.imageName)
                    .resizable()
                    .clipShape(Circle())
                    //.overlay(Circle().stroke(Color.blue, lineWidth: 3))
                    .frame(width: 80, height: 80)
                VStack (alignment: .leading) {
                    Text(category.title)
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Text(category.description).font(.subheadline)
                        .lineLimit(nil)
                }.padding(.init(top: 4, leading: 4, bottom: 4, trailing: 0))
            }
        }
    }
}

struct WorkoutMenuView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutMenuView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
    }
}

