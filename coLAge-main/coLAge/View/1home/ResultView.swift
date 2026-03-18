//
//  ResultView.swift
//  coLAge
//
//  Created by Developer on 5/5/25.
//
import SwiftUI
import MapKit

struct ResultView: View {
    @EnvironmentObject private var appState: AppState
    let sports: Int
    let nightlife: Int
    let creativity: Int
    
    var topCategory: String {
        let maxScore = max(sports, nightlife, creativity)
        switch maxScore {
        case sports: return "Sports Events"
        case nightlife: return "Nightlife Events"
        case creativity: return "Creativity Events"
        default: return "Undecided"
        }
    }
    
    var body: some View {
        VStack {
            Text("RESULTS:")
                .font(.title)
                .fontWeight(.bold)
            
            Text("You seem like: \(topCategory)")
                .font(.title)
                .padding()
            
            Text("Here are some events to help connect with that community in the LA area.")
                .padding(.bottom)
            
            MapView(topCategory: topCategory)
                .frame(maxHeight: .infinity)
                .onAppear {
                    appState.topCategory = topCategory
                }
            
        }
        .padding()
    }
}

struct MapView: View {
    var topCategory: String
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), // Default to LA
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: getEventLocations(topCategory)) { location in
            MapMarker(coordinate: location.coordinate, tint: .red)
        }
    }
}
