//
//  ViewController.swift
//  How Do I Get There?
//
//  Created by Maciej Sałuda on 28/01/2022.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController,MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    
    let locationManager: CLLocationManager = CLLocationManager()
    var routeManager = RouteManager()
    var routeModel: RouteModel?
    var userLocation: CLLocation?
    var destinationLocation: CLLocation?
    let annotation = MKPointAnnotation()
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "RouteViewController") as? RouteViewController {
            vc.modalPresentationStyle = .fullScreen
            vc.setup(manager: routeManager, route: routeModel)
            self.present(vc, animated: true, completion: nil)
            mapView.removeAnnotation(annotation)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        routeManager.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,action:#selector(handleTap))
        mapView.addGestureRecognizer(gestureRecognizer)
        mapView.mapType = MKMapType.standard
        gestureRecognizer.delegate = self
        
        
        
    }
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        
        destinationLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        guard let user = userLocation, let destination = destinationLocation else {
            return
        }
        routeManager.fetchRoute(userLocation: user, destinationLocation: destination)
       
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        userLocation = locations.last
    }
}

extension MainViewController: RouteManagerDelegate {
    func didUpdateRoute(routeModel: RouteModel) {
        self.routeModel = routeModel
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
}





