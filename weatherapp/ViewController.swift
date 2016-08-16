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
        //print("city: \(city!)")
        weatherService.getWeather(city!)
        
    }
    
    func setWeather() {
        print("hello from the deleegate siiide")
        
    }
    func error() {
        
    }
    
}

