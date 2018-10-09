//
//  MainMapViewController.swift
//  LocationTest
//
//  Created by Николай Войтович on 10/1/18.
//  Copyright © 2018 Николай Войтович. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol MainMapViewInterface: class {
  func configure(with cities: [City])
  func configure(with kilometers: String)
  func showTheEndOfTheGame()
  func configure(nextCity: City, citiesGuessed: Int, currentScore: Int)
}

class MainMapViewController: UIViewController {
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var placeButtonOutlet: UIButton!
  @IBOutlet weak var pointLabel: UILabel!
  @IBOutlet weak var nextCityLabel: UILabel!
  @IBOutlet weak var mapView: GMSMapView!
  
  let presenter: MainMapPresenterInterface = MainMapPresenter()
  
  private var currentMarker: GMSMarker?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    placeButtonOutlet.isEnabled = false
    mapView.delegate = self
    
    configureMapView()
    
    presenter.viewIsReady(viewInterface: self)
  }
  
  private func configureMapView() {
    do {
      if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
        mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
      } else {
        NSLog("Unable to find style.json")
      }
    } catch {
      NSLog("One or more of the map styles failed to load. \(error)")
    }
  }
  
  @IBAction func placeButtonWasTapped(_ sender: UIButton) {
    guard let currentMarker = currentMarker else { return }
    let currentMarkerLocation = CLLocation(latitude: currentMarker.position.latitude,
                                           longitude: currentMarker.position.longitude)
    presenter.placeButtonWasTapped(withLocation: currentMarkerLocation)
    placeButtonOutlet.isEnabled = false
  }
  
}

extension MainMapViewController: MainMapViewInterface {
  func configure(nextCity: City, citiesGuessed: Int, currentScore: Int) {
    mapView.clear()
    nextCityLabel.text = "Select the location of the \(nextCity.name)"
    scoreLabel.text = "\(currentScore) kilometers left"
    pointLabel.text = "\(citiesGuessed) cities guessed"
  }
  
  func showTheEndOfTheGame() {
    let alert = UIAlertController(title: "End", message: "End of the game", preferredStyle: .alert)
    let startNewGameAction = UIAlertAction(title: "Start new game", style: .default, handler: { _ in
      self.presenter.resetAndStartNewGame()
    })
    alert.addAction(startNewGameAction)
    present(alert, animated: true, completion: nil)
  }
  
  func configure(with kilometers: String) {
    guard kilometers == "" else {return}
    pointLabel.text = kilometers
  }
  
  func configure(with cities: [City]) {
    guard let firstCity = cities.first else { return }
    nextCityLabel.text = "Select the location of the \(firstCity.name)"
  }
  
}

extension MainMapViewController: GMSMapViewDelegate {
  func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    mapView.clear()
    currentMarker = GMSMarker()
    currentMarker?.position = coordinate
    currentMarker?.title = "your choice"
    currentMarker?.map = mapView
    placeButtonOutlet.isEnabled = true
  }
}
