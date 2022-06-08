//
//  ExerciseListView.swift
//  UI
//
//  Created by user196345 on 5/26/22.
//

import SwiftUI
import AVKit

struct ExerciseListView: View {
    let categoryId: Int
    
    var exercises: [Exercise] = []
    var dm = DataManagerClass()
    
    init(CategoryId: Int){
        categoryId = CategoryId
        exercises = dm.getExercises(categoryId: categoryId)
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
            /*
            List{
                ForEach(exercises) {exercise in
                    ExerciseRow(exercise: exercise)
                }
            }*/
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(exercises) {exercise in
                        ExerciseRow(exercise: exercise)
                    }
                }
            }
            
            .navigationBarTitle(Text(dm.getCategory(id: categoryId).title))
            
        }
    
}

struct ExerciseRow: View {
    let exercise: Exercise
    @State private var showExercise = false
    
    var body: some View {
        //NavigationLink(destination: ExerciseView(ExerciseId: exercise.id))
        Button(action: {
            showExercise = true
        }) {
            VStack{
                Image(exercise.imageName)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                Text(exercise.title)
                    .font(.headline)
                    .padding(.bottom, 2)
            }
        }
        .sheet(isPresented: $showExercise, content: {
            ExerciseView(currentExercise: exercise)
        })
    }
}


struct ExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let exercise: Exercise
    let instructions: [Instruction]
    
    init(currentExercise: Exercise){
        exercise = currentExercise
        instructions = exercise.instructions
    }
    
    var body: some View {
        VStack (alignment: .center, spacing: 20) {
            Text(exercise.title)
                .font(.headline)
            
            ScrollView{
                ForEach(instructions) {instruction in
                    if (instruction.type == "text")
                    {
                        Text(instruction.data)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    else if (instruction.type == "image")
                    {
                        Image(instruction.data)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    else if (instruction.type == "movie")
                    {
                        VideoPlayer(player: AVPlayer(url: Bundle.main.url(forResource:instruction.data, withExtension: "mp4")!))
                            .frame(height: 300)
                    }
                    
                }
                
                
            }
            
            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
        }.padding(20)
        
    }
}
