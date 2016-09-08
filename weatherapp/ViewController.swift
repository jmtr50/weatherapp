//
//  ViewController.swift
//  weatherapp
//
//  Created by jose marbin tapia rodriguez on 16/8/16.
//  Copyright © 2016 jose marbin tapia rodriguez. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDelegate, UISearchBarDelegate,
    UISearchDisplayDelegate,WeatherServiceDelegate, CLLocationManagerDelegate,
UITableViewDataSource{
    
    
    
    let weatherService = WeatherService()
    let locationManager = CLLocationManager()
    var cities = [String]()
    var citiesResult = [String]()
    var shouldShowResults = false
    
    
    
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!

    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.weatherService.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        cities = ["Madrid","San Francisco","London","New York","Paris","Bogota","Barcelona"]
        self.cityTableView.reloadData()
    }

    
    @IBAction func customSerach(sender: AnyObject) {
        showWeatherAlert()
    }
    func showWeatherAlert(){
        
        //create alert
        let alertController = UIAlertController(title: "Weather search", message: "search weather of  cities", preferredStyle: .Alert )
        
        //add a textfield
        alertController.addTextFieldWithConfigurationHandler{(textField:UITextField)-> Void in
            textField.placeholder = "introduce city name"
            
        }
        
        //add actions
        
        let cancel = UIAlertAction(title: "cancel",style:UIAlertActionStyle.Default, handler: nil)
        let search = UIAlertAction(title: "search",style:UIAlertActionStyle.Default){ ( action: UIAlertAction)-> Void in
            
            if let field = alertController.textFields![0] as UITextField!{
                //calls the weather
                self.firstWeather(field.text!)
                
            }
            
        }
        
        alertController.addAction(search)
        alertController.addAction(cancel)
        
        //show alerController
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(shouldShowResults){
            return self.citiesResult.count
        }else{
            return self.cities.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)->UITableViewCell {
        let cityCell = self.cityTableView.dequeueReusableCellWithIdentifier("cityCell",forIndexPath: indexPath)as UITableViewCell
        if(shouldShowResults){
            cityCell.textLabel!.text = citiesResult[indexPath.row]
        }else{
            cityCell.textLabel!.text = cities[indexPath.row]
        }
        
        return cityCell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        shouldShowResults = true
        searchBar.endEditing(true)
        self.cityTableView.reloadData()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        citiesResult = cities.filter({(city: String)->Bool in
            return city.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })
        
        if searchText != ""{
            shouldShowResults = true
        }else{
            shouldShowResults = false
        }
        self.cityTableView.reloadData()
    }
}

