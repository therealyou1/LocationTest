//
//  ScoreManager.swift
//  LocationTest
//
//  Created by Николай Войтович on 10/2/18.
//  Copyright © 2018 Николай Войтович. All rights reserved.
//

import Foundation

protocol ScoreManager {
  func updateScore(distanceBetweenTwoPoints: Int)
  var currentScore: Int { get set }
  var citiesGuessed: Int { get set }
  var currentRound: Int { get set }
  func reset()
}

class ScoreManagerImpl {
  var currentScore = 1500
  var citiesGuessed = 0
  var currentRound = 0
}

extension ScoreManagerImpl: ScoreManager {
  func reset() {
    currentScore = 1500
    citiesGuessed = 0
  }
  
  func updateScore(distanceBetweenTwoPoints: Int) {
    currentRound += 1
    if distanceBetweenTwoPoints <= 50 {
      citiesGuessed += 1
    } else {
      currentScore -= distanceBetweenTwoPoints
    }
  }
  
  
}
