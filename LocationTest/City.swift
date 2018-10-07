//
//  File.swift
//  LocationTest
//
//  Created by Николай Войтович on 10/1/18.
//  Copyright © 2018 Николай Войтович. All rights reserved.
//

import Foundation

struct CitiesResponse: Decodable {
  let capitalCities: [City]
}

struct City: Decodable {
  let name: String
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
  }
  
  enum CodingKeys: String, CodingKey {
    case name = "capitalCity"
  }
}
