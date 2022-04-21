//
//  WeatherManager.swift
//  Clima
//
//  Created by Adithyah Nair on 20/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: - WeatherManagerDelegate Protocol

protocol WeatherManagerDelegate {
    
    func updateWeather(_ weatherModel: WeatherModel)
    
    func updateError(_ error: Error)
    
}

struct WeatherManager {

    var delegate: WeatherManagerDelegate?

}
