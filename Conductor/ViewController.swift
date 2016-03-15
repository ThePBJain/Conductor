//
//  ViewController.swift
//  Conductor
//
//  Created by Pranav Jain on 3/13/16.
//  Copyright © 2016 Pranav Jain. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var coord: UITextView!
    
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations = \(locations)")
        let latitude: (Double!) = locations.first?.coordinate.latitude
        let longitude: (Double!) = locations.first?.coordinate.longitude
        let speed: (Double!) = locations.first?.speed
        gpsLabel.text = "Success"
        coord.text = "Latitude: \(latitude)\nLongitude: \(longitude)\nSpeed: \(speed) m/s"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}