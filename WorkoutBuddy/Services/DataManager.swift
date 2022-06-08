//
//  DataManager.swift
//  UI
//
//  Created by user196345 on 5/26/22.
//

import SwiftUI

struct WorkoutCategory: Identifiable{
    var id: Int
    
    let title, description, imageName: String
}

struct Instruction: Identifiable{
    var id: Int
    let type, data: String
}

struct Exercise: Identifiable{
    var id: Int
    let workoutCategoryId: Int
    let title, imageName: String
    let instructions: [Instruction]
}

let categories: [WorkoutCategory] = [
    .init(id: 0, title: "Chest", description: "Bench Press, Dips", imageName: "category_chest"),
    .init(id: 1, title: "Back", description: "Barbell Deadlift, Pull ups", imageName: "category_back"),
    .init(id: 2, title: "Arms", description: "Hammer Curls, Bicep Curls", imageName: "category_arms"),
    .init(id: 3, title: "Abdominals", description: "Bicycle Crunches, Pull ups", imageName: "category_abs"),
    .init(id: 4, title: "Legs", description: "Squats, Suicides", imageName: "category_legs"),
]

/*
 """
     
     
     
     
     5. Next, exhale and press the bar up, keeping your wrists straight and your back flat.
     """

 */

let exercises: [Exercise] = [
    .init(id: 0, workoutCategoryId: 0, title: "Bench Press", imageName: "chest_1", instructions: [
        .init(id: 0, type: "text", data: """
            1. Position yourself on the bench with your feet firmly on the ground and your back flat (the bar should be directly over your eyes, and your head, shoulders, and buttocks should be on the bench).
            2. Grasp the barbell with palms forward and thumbs wrapped around the bar. Move the bar into starting position, with help from a spotter if needed.
            3. Position the bar over your chin or upper chest, keeping your elbows and wrists straight.
            """),
        .init(id: 1, type: "image", data:"chest_1"),
        .init(id: 2, type: "text", data: "4. Inhale and lower the bar slowly until it touches your chest below your armpits. As you lower, flare your elbows out slightly."),
        .init(id: 3, type: "image", data:"chest_benchpress_down"),
        .init(id: 4, type: "text", data: "Check out this video demonstrating the exercise!"),
        .init(id: 5, type: "movie", data:"chest_benchpress_movie")
    ]),
    
    .init(id: 1, workoutCategoryId: 0, title: "Dips", imageName: "chest_6", instructions: [
        .init(id: 0, type: "image", data:"chest_6"),
        .init(id: 1, type: "text", data: """
            1. Grasp the parallel dip bars firmly and lift your body.
            2. Keep your elbows straight, your head in line with your trunk, and your wrists in line with your forearms.
            3. Bring one leg across the other to stabilize the lower part of your body, and pull in your abs.
            4. Exhale, and bend your elbows to lower your body. Keep your elbows near your sides. Your legs should be directly under your body to avoid tilting or swinging.
            5. Lower yourself until your elbows are at a 90-degree angle and your upper arms are parallel with the floor. Keep your wrists straight.
            6. Pause, and then straighten your elbows, pushing into the bars with your hands, and return to starting position. Keep your body vertical and your wrists straight.
            """)
    ]),
    
    .init(id: 2, workoutCategoryId: 0, title: "Pushups", imageName: "chest_7", instructions: [
        .init(id: 0, type: "image", data:"chest_7"),
        .init(id: 1, type: "text", data: """
            1. Tighten your abdominals, keep your back flat, your neck in alignment with your spine, and keep your elbows close to your sides.
            2. With your hands directly under your shoulders, lower yourself slowly and with control.
            3. Lastly, press up.
            """)
    ]),
    
    .init(id: 3, workoutCategoryId: 1, title: "Barbell Deadlift", imageName: "back_ex", instructions: [
        .init(id: 0, type: "image", data:"back_ex"),
        .init(id: 1, type: "text", data: """
            1. Stand behind the barbell with your feet shoulder-width apart.
            2. Keeping your chest lifted, begin to hinge at the hips and slowly bend your knees, reaching down to pick up the barbell. Keep your back straight and grasp the bar with both palms facing you in an overhand grip.
            3. Push back up, keeping your feet flat on the floor, back into the starting position. Your back should remain straight throughout the movement. Your shoulders should be down and back.
            4. Return to the starting position, pushing your hips back and bending your knees until you bring the barbell back to the ground.
            5. Complete 3 sets of 12 reps.
            """)
    ]),
    
    .init(id: 4, workoutCategoryId: 2, title: "Hammer Curls", imageName: "arms_ex", instructions: [
        .init(id: 0, type: "image", data:"arms_ex"),
        .init(id: 1, type: "text", data: """
            Hold a dumbbell in each hand with palms facing your sides and arms extended straight down. Keeping your upper arms against your sides, curl both weights at the same time, minimizing momentum used during the curl.
            """)
    ]),
    
    .init(id: 5, workoutCategoryId: 3, title: "Bicycle Crunches", imageName: "abs_ex", instructions: [
        .init(id: 0, type: "image", data:"abs_ex"),
        .init(id: 1, type: "text", data: """
            To complete a bicycle crunch, lie on your back with your lower back pressed into the ground, bring your knees in towards your chest and lift your shoulder blades off the ground. Straighten your right leg, whist turning your upper body to the left, bringing your right elbow towards the left knee.
            """)
    ]),
    
    .init(id: 6, workoutCategoryId: 4, title: "Squats", imageName: "legs_ex", instructions: [
        .init(id: 0, type: "image", data:"legs_ex"),
        .init(id: 1, type: "text", data: """
            The squat is one of the best exercises to tone legs. It also sculpts the butt, hips, and abs.

            Squats are ideal if you have back problems. Since they’re done while standing up and without extra weight, they won’t strain the back.

            For balance or extra support, perform your squats standing alongside a wall or next to a chair or the edge of a table with one hand on the object. Resist the urge to pull on it or push off from it.
            """)
    ]),

/*

    .init(id: 3, workoutCategoryId: 1, title: "Situps3", instructions: "Do it", imageName: "category_abs"),
    .init(id: 4, workoutCategoryId: 2, title: "Situps4", instructions: "Do it", imageName: "category_abs"),
    .init(id: 5, workoutCategoryId: 2, title: "Situps5", instructions: "Do it", imageName: "category_abs")
    */
]

class DataManagerClass{
    
    func getCategories()->[WorkoutCategory]
    {
        return categories
    }
    
    func getCategory(id: Int) -> WorkoutCategory
    {
        for category in categories {
            if (category.id == id)
            {
                return category;
            }
        }
        return categories[0]
    }

    func getExercises(categoryId: Int)->[Exercise]
    {
        var goodExercises: [Exercise] = []
        
        for exercise in exercises {
            if (exercise.workoutCategoryId == categoryId)
            {
                goodExercises.append(exercise);
            }
        }
        
        return goodExercises
    }
    
    func getExercise(id: Int) -> Exercise
    {
        for exercise in exercises {
            if (exercise.id == id)
            {
                return exercise;
            }
        }
        return exercises[0]
    }

}


class SharedViewInformation: ObservableObject {
    @Published var categoryId = 0
}
