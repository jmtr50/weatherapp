//
//  weatherService.swift
//  weatherapp
//
//  Created by jose marbin tapia rodriguez on 16/8/16.
//  Copyright © 2016 jose marbin tapia rodriguez. All rights reserved.
//

import Foundation

class WeatherService{
    
    var delegate: WeatherServiceDelegate!
    
    func getWeather(city:String) -> Void {
        print("get the weather for \(city)")
        
        if delegate != nil{
            delegate?.setWeather()
        }
    }
}