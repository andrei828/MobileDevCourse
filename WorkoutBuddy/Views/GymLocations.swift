//
//  GymLocations.swift
//  WorkoutBuddy
//
//  Created by Andrei Liviu on 25/05/2022.
//

import SwiftUI
import MapKit

struct Landmark: Identifiable {
    
//    let placemark: MKPlacemark
    
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
//    var name: String {
//        self.placemark.name ?? ""
//    }
//
//    var title: String {
//        self.placemark.title ?? ""
//    }
//
//    var coordinate: CLLocationCoordinate2D {
//        self.placemark.coordinate
//    }
}

final class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D

    init(landmark: Landmark) {
        self.title = landmark.name
        self.coordinate = landmark.coordinate
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion()
    @Published var landmarks: [Landmark] = []
    
    var isSet = false
    
    private let manager = CLLocationManager()
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Gym"

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
               
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(name: $0.placemark.name ?? "Undefined", coordinate: $0.placemark.coordinate)
                }
               
           }
           
        }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("did scroll")
        if isSet == false {
            print("I'm here")
            locations.last.map {
                let center = CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                region = MKCoordinateRegion(center: center, span: span)
            }
            isSet = true
        }
    }
}


struct GymLocations: View {

    @StateObject private var manager = LocationManager()
    
    @State private var test = false
    let annotations = [
            Landmark(name: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)),
            Landmark(name: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508)),
            Landmark(name: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5)),
            Landmark(name: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667))
        ]
    
    var body: some View {
        Map(coordinateRegion: $manager.region, showsUserLocation: true, annotationItems: manager.landmarks) { item in
            MapAnnotation(coordinate: item.coordinate) {
                Image(systemName: "mappin")
                    .foregroundColor(.red)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                if manager.region.span.latitudeDelta < 0.05 {
                    Text(item.name)
                }
            }
        }
    }
}

struct GymLocations_Previews: PreviewProvider {
    static var previews: some View {
        GymLocations()
    }
}
