//
//  ViewController.swift
//  weatherapp
//
//  Created by jose marbin tapia rodriguez on 16/8/16.
//  Copyright © 2016 jose marbin tapia rodriguez. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, WeatherServiceDelegate, CLLocationManagerDelegate{
    
    let weatherService = WeatherService()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.weatherService.delegate = self
    }

    
    
    func locationManager(manager: CLLocationManager ,  didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
            if error != nil{
                print("error")
            }else{
                
                if(placemarks!.count > 0){
                    let pm = placemarks![0]
                    self.firstWeather(pm.locality!)
                    self.locationManager.stopUpdatingLocation()
                }
                
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func firstWeather( city:String ){
       cityLabel.text = city
        weatherService.getWeather(city)
    }
    @IBAction func searchWeather(sender: AnyObject) {
        let city = cityTextField.text
        weatherService.getWeather(city!)
        
    }
    
    func setWeather(weather:Weather) {
    
        currentWeatherLabel.text = weather.description
        currentWeatherImage.image = UIImage(named: weather.icon)
        humidityLabel.text = "💧\(weather.humidity) %"
        tempLabel.text = "🌡\(weather.temp)º"
        
    }
    func error(message:String) {
        let alertController = UIAlertController(title: "Error", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
         currentWeatherImage.image = UIImage(named: "cloud_sm")
         humidityLabel.text = "💧000%"
         tempLabel.text = "🌡000º"
         currentWeatherLabel.text = "???????"
    }
    
}

