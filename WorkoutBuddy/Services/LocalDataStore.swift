//
//  LocalDataStore.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 11/05/2022.
//

import Foundation
import RealmSwift

// LocalOnlyQsTask is the Task model for this QuickStart
class LocalWeightPoint: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var timestamp: Date = Date()
    @objc dynamic var value: Float = 0
    convenience init(id: String, value: Float, timestamp: Date) {
        self.init()
        self.id = id
        self.value = value
        self.timestamp = timestamp
    }
}

class LocalDataStore {
 
    static var data: [WeightPoint] = [WeightPoint(id: UUID().uuidString, timestamp: Date(timeIntervalSinceReferenceDate: -123456789.0), weightValue: 34.4), WeightPoint(id: UUID().uuidString, timestamp: Date(), weightValue: 65.7)]
    
    static var localRealm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    init() {
        
    }
        
    static func getLocalWeightHistory() -> [WeightPoint] {
        var result: [WeightPoint] = []
        let localWeightPoints = localRealm.objects(LocalWeightPoint.self)
        for weightPoint in localWeightPoints {
            result.append(WeightPoint(id: weightPoint.id, timestamp: weightPoint.timestamp, weightValue: weightPoint.value))
        }
        return result
    }
    
    static func getLocalWeightHistoryAscendingOrder() -> [WeightPoint] {
        var result: [WeightPoint] = []
        let localWeightPoints = localRealm.objects(LocalWeightPoint.self)
        for weightPoint in localWeightPoints.sorted(by: { (a, b) -> Bool in
            return a.timestamp > b.timestamp
        }) {
            result.append(WeightPoint(id: weightPoint.id, timestamp: weightPoint.timestamp, weightValue: weightPoint.value))
        }
        
        return result
    }
    
    static func addNewDateToDabase(value: Float, newDate: Date) -> Bool {
        /**
         Will check for validity of data
         */
        if (value < 0) {
            return false
        }
//        LocalDataStore.data.append(WeightPoint(timestamp: newDate, weightValue: value))
        let weightPoint = LocalWeightPoint(id: UUID().uuidString, value: value, timestamp: newDate)
        try! LocalDataStore.localRealm.write {
            LocalDataStore.localRealm.add(weightPoint)
        }
        return true
    }
    
    static func editCurrentDateToDatabase(timestamp: Date, value: Float) -> Bool {
        if !LocalDataStore.isValidTimestamp(timestamp: timestamp) {
            return false
        }
        
        for var weightPoint in LocalDataStore.data {
            if weightPoint.timestamp == timestamp {
                weightPoint.weightValue = value
                return true
            }
        }
        
        /**
         if this line is ran then an error has occurred
         */
        return false
    }
    
    static func editCurrentDateToDatabase(id: String, weight: Float, date: Date) -> Bool {
        let localWeightPoints = localRealm.objects(LocalWeightPoint.self)
        let resultWeightPoint = localWeightPoints.filter("id == %@", id)
        try! LocalDataStore.localRealm.write {
            resultWeightPoint[0].value = weight
            resultWeightPoint[0].timestamp = date
        }
        return true
    }
    
    static func removeDateFromDatabase(timestamp: Date) -> Bool {
        LocalDataStore.data.removeAll { $0.timestamp == timestamp }
        return true
    }
    
    static func removeDateFromDatabase(id: String) -> Bool {
        let localWeightPoints = localRealm.objects(LocalWeightPoint.self)
        let resultWeightPoint = localWeightPoints.filter("id == %@", id)
        try! LocalDataStore.localRealm.write {
            localRealm.delete(resultWeightPoint)
        }
        return true
    }
    
    static func restoreAllDatesFromDatabase(newDates: [WeightPoint]) -> Bool {
        LocalDataStore.data = newDates
        try! LocalDataStore.localRealm.write {
            LocalDataStore.localRealm.deleteAll()
        }
        
        for points in newDates {
            if LocalDataStore.addNewDateToDabase(value: points.weightValue, newDate: points.timestamp) == false {
                print("There was an error when restoring the local database")
            }
        }
        
        return true
    }
    
    /**
     Check wheter the timestamp is in a valid format and is present in the local storage
     */
    static func isValidTimestamp(timestamp: Date) -> Bool {
        for weightPoint in self.data {
            if weightPoint.timestamp == timestamp {
                return true
            }
        }
        return false
    }
}
