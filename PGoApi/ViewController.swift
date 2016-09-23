//
//  ViewController.swift
//  PGoApi
//
//  Created by Luke Sapan on 08/02/2016.
//  Copyright (c) 2016 Luke Sapan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import PGoApi

class ViewController: UIViewController,CLLocationManagerDelegate, PGoAuthDelegate, PGoApiDelegate {
    
    var auth: PGoAuth!
    var request = PGoApiRequest()
    var mapCells = Pogoprotos.Networking.Responses.GetMapObjectsResponse()
    let locationManager = CLLocationManager()
    
    enum AuthMethod {
        case PTC
        case Google
    }
    
    @IBOutlet weak var authSegment: UISegmentedControl!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var latField: UITextField!
    @IBOutlet weak var longField: UITextField!
    
    @IBAction func login(sender: UIButton) {
        switch authSegment.selectedSegmentIndex {
        case AuthMethod.PTC.hashValue:
            auth = PtcOAuth()
        case AuthMethod.Google.hashValue:
            auth = GPSOAuth()
        default:
            break
        }
        
        auth.delegate = self
        if usernameTextField.text! == "" || passwordTextField.text! == "" {
            showAlert("Error", message: "Login details are incomplete.")
            return
        }
        auth.login(withUsername: usernameTextField.text!, withPassword: passwordTextField.text!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showMap") {
            let pokeMap:PokemonMap = segue.destinationViewController as! PokemonMap
            pokeMap.mapCells = mapCells
            pokeMap.auth = auth
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        auth = PtcOAuth()
        auth.delegate = self
        super.viewDidLoad()
    }
    
    func didReceiveAuth() {
        print("Auth received!!")
        print("Starting simulation...")
        request = PGoApiRequest(auth: auth)
        // 设置定位的精确度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 设置定位变化的最小距离 距离过滤器
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        request.setLocation(Double("37.33161821509")!, longitude: Double("-122.0298043927")!, altitude: 10)
        request.simulateAppStart()
        request.makeRequest(.Login, delegate: self)
    }
    
    func didNotReceiveAuth() {
        showAlert("Error", message: "Failed to auth.")
        print("Failed to auth!")
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        print("Got that API response: \(intent)")
        if (intent == .Login) {
            request.getMapObjects()
            request.makeRequest(.GetMapObjects, delegate: self)
        } else if (intent == .GetMapObjects) {
            print("Got map objects!")
            mapCells = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetMapObjectsResponse
            
            performSegueWithIdentifier("showMap", sender: nil)
        }
    }
    
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        print("API Error: \(statusCode)")
    }
}

