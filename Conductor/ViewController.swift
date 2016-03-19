//
//  ViewController.swift
//  Conductor
//
//  Created by Pranav Jain on 3/13/16.
//  Copyright © 2016 Pranav Jain. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
class ViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var coord: UITextView!
    var pickerDataSource = ["1 second", "2 seconds", "3 seconds", "4 seconds", "5 seconds"]
    var previousTime:Int! = 1000
    var interval = 1000
    var locationManager:CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations = \(locations)")
        let latitude: (Double!) = locations.first?.coordinate.latitude
        let longitude: (Double!) = locations.first?.coordinate.longitude
        let speed: (Double!) = locations.first?.speed
        var timestamp = NSDate().timeIntervalSince1970
        timestamp *= 1000;
        let time:Int = Int(timestamp)
        gpsLabel.text = "Success"
        coord.text = "Latitude: \(latitude)\nLongitude: \(longitude)\nSpeed: \(speed) m/s"
        let params = [
            "id": "567",
            "ts" : "\(time)",
            "lt":"\(latitude)",
            "lg":"\(longitude)"] as Dictionary<String, String>
        
        //POST DATA
        if(previousTime+interval < time){
            previousTime = time
            postData("https://gps.hyperloop.azure-cloud.catalysts.cc/gps", params: params) { (data, response, error) -> Void in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
            }
        }
    }
    //post data
    func postData(url: String, params: Dictionary<String, String>, completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> ()) {
        
        // Indicate download
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let url = NSURL(string: url)!
        //        print("URL: \(url)")
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // Verify downloading data is allowed
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch let error as NSError {
            print("Error in request post: \(error)")
            request.HTTPBody = nil
        } catch {
            print("Catch all error: \(error)")
        }
        
        // Post the data
        let task = session.dataTaskWithRequest(request) { data, response, error in
            completionHandler(data: data, response: response, error: error)
            
            // Stop download indication
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false // Stop download indication
            
        }
        
        task.resume()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //making the PickerView work
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if(row == 0)
        {
            interval = 1000
        }
        else if(row == 1)
        {
            interval = 2000
        }
        else if(row == 2)
        {
            interval = 3000
        }
        else if(row == 3)
        {
            interval = 4000
        }
        else
        {
            interval = 5000
        }
    }

}