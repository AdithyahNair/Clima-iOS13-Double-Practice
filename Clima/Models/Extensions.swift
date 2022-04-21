//
//  Extensions.swift
//  Clima
//
//  Created by Adithyah Nair on 21/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

extension WeatherViewController: UITextFieldDelegate {
    
    //MARK: - textFieldShouldReturn()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        
        return true
        
    }
    
    //MARK: - textFieldShouldEndEditing()
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            
            return true
            
        } else {
            
            textField.placeholder = "Enter a city name"
            return false
            
        }
        
    }
    
    //MARK: - textFieldDidEndEditing()
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        getCityName()
            
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    //MARK: - locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error in receiving location data. Error: \(error)")
        
    }
    
    //MARK: - locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            let latitude = location.coordinate.latitude
            
            let longitude = location.coordinate.longitude
            
            weatherManager.fetchData(latitude,longitude)
            
        }
        
        locationManager.stopUpdatingHeading()
        
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
    //MARK: - updateWeather()
    
    func updateWeather(_ weatherModel: WeatherModel) {
        
        DispatchQueue.main.async {
            
            self.cityLabel.text = weatherModel.name
            
            self.temperatureLabel.text = weatherModel.temperatureString
            
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            
        }

    }
    
    //MARK: - updateError()
    
    func updateError(_ error: Error) {
        
        print("Weather could not be updated. Error: \(error)")
        
    }
    
}

extension WeatherViewController {
    
    //MARK: - searchPressed @IBAction
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        getCityName()
        
        textField.endEditing(true)
        
    }
    
    //MARK: - getCityName()
    
    func getCityName() {
        
        if let cityName = textField.text {
            
            weatherManager.fetchData(cityName)
            
        }

        textField.text = ""
        
    }
    
    //MARK: - findMyLocationPressed()
    
    @IBAction func findMyLocationPressed(_ sender: UIButton) {
        
        locationManager.requestLocation()
    }

}

extension WeatherManager {
    
    //MARK: - fetchData(_ cityName: String)
    
    func fetchData(_ cityName: String) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=87c1880ccffcaaeed5a99fae41c43c72&units=metric"
        
        performNetworking(urlString)
        
    }
    
    //MARK: - fetchData(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees)
    
    func fetchData(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=87c1880ccffcaaeed5a99fae41c43c72&units=metric"
        
        performNetworking(urlString)
        
    }
    
    //MARK: - performNetworking()
    
    func performNetworking(_ urlString: String)  {
        
        if let url = URL(string: urlString) {
            
            let urlSession = URLSession(configuration: .default)
            
            let task = urlSession.dataTask(with: url) { data, response, error in
                
                if let safeData = data {
                    
                    if let weather = parseJSON(safeData) {
                        
                        delegate?.updateWeather(weather)
                        
                    }
                    
                } else {
                    
                    if let safeError = error {
                        
                        print("Error parsing data. Error: \(safeError)")
                        
                        delegate?.updateError(safeError)
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    //MARK: - parseJSON()
    
    func parseJSON(_ safeData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(WeatherData.self, from: safeData)
            
            let cityName = decodedData.name
            
            let temp = decodedData.main.temp
            
            let id = decodedData.weather[0].id
            
            let weatherModel = WeatherModel(name: cityName, temp: temp, conditionID: id)
            
            return weatherModel
            
        } catch {
            
            print("Error decoding data. Error:\(error)")
            
            return nil
            
        }
        
    }
    
}
