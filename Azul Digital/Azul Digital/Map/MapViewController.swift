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

class MapViewController: UIViewController, FBServerTime {
    
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
    @IBAction func unwindToMap(withSegue segue: UIStoryboardSegue) {
    }
    

    @IBAction func requestLocation(_ sender: AnyObject) {
        requestUserLocation()
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        requestUserLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.barTintColor = UIColor(red: 15/255, green: 127/255, blue: 223/255, alpha: 1)
        buy.setImage(UIImage(named: NSLocalizedString("Buy", comment: "buy-map")) , for: .normal)
        buy.setImage(UIImage(named: NSLocalizedString("Buy_enabled", comment: "buy-map-enabled")) , for: .highlighted)
        locationTextField.leftViewMode = .always
        let addImageView = UIView(frame: CGRect(x: 0, y: 11, width: 22, height: 44))
        let image = UIImage(named: "annotation")
        let imageView = UIImageView(frame: CGRect(x: 6, y: 11, width: 22, height: 22))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addImageView.addSubview(imageView)
        locationTextField.leftView = addImageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BuySegue" {
            guard let destination = segue.destination as? BuyTicketViewController else { return }
            destination.address = locationTextField.text ?? "Empty Address"
        } else if segue.identifier == "ShareSegue" {
            guard let destination = segue.destination as? ShareViewController else { return }
            savetime()
            destination.address = locationTextField.text ?? "Empty Address"
        }  else if segue.identifier == "postSegue" {
            guard let _ = segue.destination as? PostsTableViewController else { return }
        }
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
