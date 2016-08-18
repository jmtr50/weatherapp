//
//  WeatherServiceDelegate.swift
//  weatherapp
//
//  Created by jose marbin tapia rodriguez on 17/8/16.
//  Copyright © 2016 jose marbin tapia rodriguez. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func setWeather(weather:Weather)
    func error(message:String)
}