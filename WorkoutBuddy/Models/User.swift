//
//  User.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 09/05/2022.
//

import FirebaseFirestoreSwift

struct User: Codable {

    @DocumentID var id: String?
    
    var name: String?
    var weightHistory: [WeightPoint]
    
    enum CodingKeys: String, CodingKey {
        case id
            case name
            case weightHistory = "weight_history"
        }
}
