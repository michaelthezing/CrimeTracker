//
//  ContentViewModel.swift
//  MapKitApp
//
//  Created by Michael Telezing
//
import SwiftUI
import Foundation
import MapKit

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683), // Default to Los Angeles
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    private var shouldCenterOnUser = true

    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 43.457105, longitude: -83.508361),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var binding: Binding<MKCoordinateRegion> {
        Binding {
            self.mapRegion
        } set: { newRegion in
            self.mapRegion = newRegion
           // User moved the map manually, stop auto-centering
        }
    }

    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
            locationManager?.startUpdatingLocation()
        } else {
            print("Show an alert letting them know this is off")
        }
    }

    func moveToLocation(_ coordinate: CLLocationCoordinate2D) {
        withAnimation {
            self.region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            shouldCenterOnUser = false
        }
    }

    func centerMapOnUserLocation() {
        shouldCenterOnUser = true
        if let location = locationManager?.location {
            withAnimation(.easeInOut(duration: 2.0)) {
                mapRegion = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
            shouldCenterOnUser = false // Stop auto-centering after moving to user's location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
             
        if shouldCenterOnUser {
            withAnimation(.easeInOut(duration: 1.0)) {
                mapRegion = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
            shouldCenterOnUser = false // Reset after centering
        }
    }
}
