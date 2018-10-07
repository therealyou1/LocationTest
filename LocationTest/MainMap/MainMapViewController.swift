//
//  MainMapViewController.swift
//  LocationTest
//
//  Created by Николай Войтович on 10/1/18.
//  Copyright © 2018 Николай Войтович. All rights reserved.
//

import UIKit
import MapKit

protocol MainMapViewInterface: class {
  func configure(with cities: [City])
  func configure(with kilometers: String)
  func update(nextCity: City, citiesGuessed: Int, currentScore: Int)
  func showTheEndOfTheGame()
  func configure(nextCity: City, citiesGuessed: Int, currentScore: Int)
}

class MainMapViewController: UIViewController {
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var placeButtonOutlet: UIButton!
  @IBOutlet weak var pointLabel: UILabel!
  @IBOutlet weak var nextCityLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  
  let presenter: MainMapPresenterInterface = MainMapPresenter()
  
  private var currentAnnotation: MKAnnotation?

  override func viewDidLoad() {
    super.viewDidLoad()
    placeButtonOutlet.isEnabled = false
    mapView.delegate = self
    
    presenter.viewIsReady(viewInterface: self)
    mapView.mapType = .standard
  }

  @IBAction func placeButtonWasTapped(_ sender: UIButton) {
    guard let currentAnnotation = currentAnnotation else { return }
    let currentAnnotationLocation = CLLocation(latitude: currentAnnotation.coordinate.latitude,
                                             longitude: currentAnnotation.coordinate.longitude)
    presenter.placeButtonWasTapped(withLocation: currentAnnotationLocation)
    placeButtonOutlet.isEnabled = false
  }
  
  @IBAction func longPressOnMapHandler(_ sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      mapView.removeAnnotations(mapView.annotations)
      let location = sender.location(in: mapView)
      let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinates
      annotation.title = "your choice"
      mapView.addAnnotation(annotation)
      placeButtonOutlet.isEnabled = true
    }
  }
}

extension MainMapViewController: MainMapViewInterface {
  func configure(nextCity: City, citiesGuessed: Int, currentScore: Int) {
    mapView.removeAnnotations(mapView.annotations)
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
  
  func update(nextCity: City, citiesGuessed: Int, currentScore: Int) {
    mapView.removeAnnotations(mapView.annotations)
    nextCityLabel.text = "Select the location of the" + nextCity.name
    scoreLabel.text = "\(currentScore) kilometers left"
    pointLabel.text = "\(citiesGuessed) cities guessed"
  }
}

extension MainMapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    guard let firstAnnotation = views.first?.annotation else { return }
    currentAnnotation = firstAnnotation
  }
}
