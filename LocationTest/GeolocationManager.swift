//
//  GeoloocationManager.swift
//  LocationTest
//
//  Created by Николай Войтович on 10/2/18.
//  Copyright © 2018 Николай Войтович. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeolocationManager {
  func getCoordinate(from cityname: String, completion: @escaping(_ coordinate: CLLocation?, _ error: Error?) -> ())
  func distanceBetweenTwoPoints(cityLocation: CLLocation,
                                pinLocation: CLLocation) -> Int
}

class GeolocationManagerImpl {
  
}

extension GeolocationManagerImpl: GeolocationManager {
  func getCoordinate(from cityname: String, completion: @escaping (CLLocation?, Error?) -> ()) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(cityname) { (placemark, error) in
      if let error = error {
        completion(nil, error)
        return
      }
      if let firstPlacemarkLocation = placemark?.first?.location {
        completion(firstPlacemarkLocation, nil)
        return
      }
      completion(nil,nil)
    }
  }
  
  func distanceBetweenTwoPoints(cityLocation: CLLocation,
                                pinLocation: CLLocation) -> Int {
    let distanceInMaters = cityLocation.distance(from: pinLocation)
    let distanceInKM = Int(distanceInMaters / 1000)
    return distanceInKM
  }
}
