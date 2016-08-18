//
//  ViewController.swift
//  weatherapp
//
//  Created by jose marbin tapia rodriguez on 16/8/16.
//  Copyright © 2016 jose marbin tapia rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherServiceDelegate{
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var currentWeatherImage: UIImageView!
    
    @IBOutlet weak var currentWeatherLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!

    let weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherService.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

