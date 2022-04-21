//
//  WeatherModel.swift
//  Clima
//
//  Created by Adithyah Nair on 20/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let name: String
    
    let temp: Double
    
    let conditionID: Int
    
    var conditionName: String {
        
        switch conditionID {
            
            case 200...232:
                return "cloud.bolt"
        
            case 300...321:
                return "cloud.drizzle"
        
            case 500...531:
                return "cloud.rain"
        
            case 600...622:
                return "cloud.snow"
        
            case 701...781:
                return "cloud.fog"
        
            case 800:
                return "sun.max"
        
            case 801...804:
                return "cloud.bolt"
        
            default:
                return "cloud"
            
        }

    }
    
    var temperatureString: String {
        
        return String(format: "%0.1f", temp)
        
    }
}
