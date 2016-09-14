//
//  MapViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 7/11/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import AddressBook
import IQKeyboardManagerSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var buy: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func logout(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "UINavigationControllerMain")
        present(initialViewController, animated: true, completion: nil)
        //        UIApplication.shared().delegate?.window??.rootViewController = initialViewController
    }
    
    @IBAction func requestLocation(_ sender: AnyObject) {
        requestUserLocation()
    }
    @IBAction func buyTicket(_ sender: AnyObject) {
        
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        requestUserLocation()
        locationTextField.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        buy.setImage(UIImage(named: NSLocalizedString("Buy", comment: "buy-map")) , for: .normal)
        buy.setImage(UIImage(named: NSLocalizedString("Buy_enabled", comment: "buy-map-enabled")) , for: .highlighted)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func requestUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = false
    }
    
    
    func getAddress(location: CLLocation) {
        CLGeocoder().cancelGeocode()
        CLGeocoder().reverseGeocodeLocation(location) { [weak self](placemarks, error) in
            if error != nil {
                print("\(error)")
            }
            guard let placemark = placemarks, let mostAccurate = placemark.first else { return }
            let street = mostAccurate.addressDictionary?["FormattedAddressLines"] as? [String]
            let formattedAddress = street?.joined(separator: ", ")

            self?.locationTextField.text = formattedAddress
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        getAddress(location: location)
        
        
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let newLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        getAddress(location: newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro: \(error.localizedDescription)")
    }

}

extension MapViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
