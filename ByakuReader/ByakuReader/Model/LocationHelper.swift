//
//  LocationHelper.swift
//  ByakuReader
//
//  Created by Arch Umeshbhai Patel on 2025-08-06.
//

import Foundation
import CoreLocation
class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onLocationUpdate: ((String?, String?) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let state = placemark.administrativeArea
            let country = placemark.country
            self.onLocationUpdate?(state, country)
        }
        locationManager.stopUpdatingLocation()
    }
}
//let locationService = LocationService()
//locationService.onLocationUpdate = { state, country in
//    print("State:", state ?? "Unknown")
//    print("Country:", country ?? "Unknown")
//}
