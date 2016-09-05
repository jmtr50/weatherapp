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

        let appId = "d200b11585e4dd245568212a047f17ce"
        let apiUrl = "http://api.openweathermap.org/data/2.5/forecast/weather?q=\(city)&APPID=\(appId)&units=metric"
        let urlEncode = apiUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string:urlEncode! )
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            
            if(error != nil) {
                // Imprimir descripcion del error si es que error NO esta vacio
                if  self.delegate != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //   print(error!.localizedDescription)
                        //imprimir error desde el delegate
                        self.delegate?.error("bad request")
                    })
                }
                
            }else{
                
                let nsdata:NSData = NSData(data: data!)
                print(nsdata)
                do{
                    
                    let jsonCompleto = try NSJSONSerialization.JSONObjectWithData( nsdata, options: NSJSONReadingOptions.MutableContainers)
                    let cod = jsonCompleto["cod"] as! String
                    if cod != "200"{
                        let message = jsonCompleto["message"] as! String
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //   print(error!.localizedDescription)
                            //imprimir error desde el delegate
                            if  self.delegate != nil{
                                self.delegate?.error(message)
                            }
                        })
                        
                    }else{
                        let weather = Weather()
                        let lista = jsonCompleto["list"]
                        
                        if let nsArrayJsonList = lista as? NSArray{
                            nsArrayJsonList.enumerateObjectsUsingBlock({ objeto, index, stop in
                                if index == 0 {
                                    let weatherAux = objeto["weather"] as! NSArray
                                    let weatherAux2 = objeto["main"] as! NSDictionary
                                    //Itinerar por todo nuestro arreglo weather
                                    weatherAux.enumerateObjectsUsingBlock({ objeto, index, stop in
                                        if index == 0 {
                                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                                weather.description = objeto["description"] as! String
                                                weather.icon = objeto["icon"] as! String
                                            })
                                        }
                                        
                                    })
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        weather.temp = "\(weatherAux2["temp"] as! NSNumber)"
                                        weather.humidity = "\(weatherAux2["humidity"] as! NSNumber)"
                                    })
                                    
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        if  self.delegate != nil{
                                            self.delegate?.setWeather(weather)
                                        }
                                    })
                                    
                                }
                                
                            })
                        }
                    }
                    
                }catch{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if  self.delegate != nil{
                            self.delegate?.error("Failed to serialize json")
                        }
                    })
                    
                }
            }
        })
        task.resume()
    }
}