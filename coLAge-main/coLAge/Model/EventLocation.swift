//
//  EventLocation.swift
//  coLAge
//
//  Created by Developer on 5/5/25.
//
import SwiftUI
import MapKit

struct EventLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

func getEventLocations(_ category: String) -> [EventLocation] {
    switch category {
    case "Sports Events":
        return [
            EventLocation(name: "Dodger Stadium", coordinate: CLLocationCoordinate2D(latitude: 34.0739, longitude: -118.2390)),
            EventLocation(name: "Crypto.com Arena", coordinate: CLLocationCoordinate2D(latitude: 34.0430, longitude: -118.2673)),
            EventLocation(name: "Intuit Dome", coordinate: CLLocationCoordinate2D(latitude: 33.9581, longitude: -118.3415))
        ]
    case "Nightlife Events":
        return [
            EventLocation(name: "USC Frat Row", coordinate: CLLocationCoordinate2D(latitude: 34.0259, longitude: -118.2856)),
            EventLocation(name: "Los Globos Nightclub", coordinate: CLLocationCoordinate2D(latitude: 34.0982, longitude: -118.2911))
        ]
    case "Creativity Events":
        return [
            EventLocation(name: "Silverlake Flea", coordinate: CLLocationCoordinate2D(latitude: 34.0924, longitude: -118.2702)),
            EventLocation(name: "LA County Museum of Art", coordinate: CLLocationCoordinate2D(latitude: 34.0638, longitude: -118.3589))
        ]
    default:
        return []
    }
}
