//
//  WeightPoint.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 11/05/2022.
//
import Foundation
import FirebaseFirestoreSwift

struct WeightPoint: Codable, Identifiable {
    
    @DocumentID var id: String?
    
    var timestamp: Date
    var weightValue: Float
    
    enum CodingKeys: String, CodingKey {
        case id
            case timestamp
            case weightValue = "weight_value"
        }
    
    init(id: String, timestamp: Date, weightValue: Float) {
        self.id = id
        self.timestamp = timestamp
        self.weightValue = weightValue
    }
}
