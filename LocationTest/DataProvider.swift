//
//  DataProvider.swift
//  LocationTest
//
//  Created by Николай Войтович on 10/2/18.
//  Copyright © 2018 Николай Войтович. All rights reserved.
//

import Foundation

protocol DataProvider {
  func obtainCities() -> CitiesResponse?
}

class DataProviderImpl {
}

extension DataProviderImpl: DataProvider {
  func obtainCities() -> CitiesResponse? {
    if let path = Bundle.main.path(forResource: "capitalCities", ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let citiesResponse = try JSONDecoder().decode(CitiesResponse.self, from: data)
        return citiesResponse
      } catch let error {
        print("parse error: \(error.localizedDescription)")
        return nil
      }
    }
    return nil
  }
}
