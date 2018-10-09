//
//  MainMapPresenter.swift
//  LocationTest
//
//  Created by Николай Войтович on 10/2/18.
//  Copyright © 2018 Николай Войтович. All rights reserved.
//

import Foundation
import CoreLocation

protocol MainMapPresenterInterface {
  func viewIsReady(viewInterface: MainMapViewInterface)
  func placeButtonWasTapped(withLocation location: CLLocation)
  func resetAndStartNewGame()
}

class MainMapPresenter {
  weak var view: MainMapViewInterface?
  
  let dataProvider: DataProvider = DataProviderImpl()
  let geolocationManager: GeolocationManager = GeolocationManagerImpl()
  let scoreManager: ScoreManager = ScoreManagerImpl()
  
  private var cities = [City]()
  
  private func obtainCurrentCityLocation(completion: @escaping (CLLocation?, Error?) -> Void) {
    guard let currentCity = cities.first else { return }
    geolocationManager.getCoordinate(from: currentCity.name) { (location, error) in
      completion(location, error)
    }
  }
}

extension MainMapPresenter: MainMapPresenterInterface {
  func viewIsReady(viewInterface: MainMapViewInterface) {
    self.view = viewInterface
    if let citiesResponse = dataProvider.obtainCities() {
      cities = citiesResponse.capitalCities
      view?.configure(with: citiesResponse.capitalCities)
    }
  }
  
  func placeButtonWasTapped(withLocation location: CLLocation) {
    obtainCurrentCityLocation { cityLocation, error in
      guard let cityLocation = cityLocation else { return }
      let distance = self.geolocationManager.distanceBetweenTwoPoints(cityLocation: cityLocation,
                                                                      pinLocation: location)
      let currentCity = self.cities.removeFirst()
      self.cities.append(currentCity)
      self.scoreManager.updateScore(distanceBetweenTwoPoints: distance)
      
      if self.scoreManager.currentScore <= 0 || self.scoreManager.currentRound == self.cities.count {
        self.view?.showTheEndOfTheGame()
        return
      }
      
      guard let nextCity = self.cities.first else { return }
      self.view?.configure(nextCity: nextCity,
                        citiesGuessed: self.scoreManager.citiesGuessed,
                        currentScore: self.scoreManager.currentScore)
    }
  }
  
  func resetAndStartNewGame() {
    self.scoreManager.reset()
    guard let nextCity = self.cities.first else { return }
    self.view?.configure(nextCity: nextCity,
                         citiesGuessed: self.scoreManager.citiesGuessed,
                         currentScore: self.scoreManager.currentScore)
  }
}
