//
//  WeatherManager.swift
//  Clima
//
//  Created by ANURAG KASHYAP on 15/11/23.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager : WeatherManager , weather : WeatherModel)
    func didFailWithError(error: Error)
}
let getWeatherURL = WeatherURL()

struct WeatherManager{
    let weatherURL = getWeatherURL.weatherURL
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        //print(urlString)
        performRequest(with: urlString)
    }
    func fetchWeather(latitude : CLLocationDegrees , longitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        //print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){
        //1. create a URL
        if let url = URL(string: urlString){
            //2. create a session
            let session = URLSession(configuration: .default)
            
            //3. give a task to URL session
            
            let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
            //4. start the task
            task.resume()
            /*
             using closures we can create task to session like this :-
             let task = session.dataTask(with : url){(data,response,error) -> Void in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let safeData = data{
                        let dataString = String(data: safeData, encoding: .utf8)
                        print(dataString as Any)
             }
             and no need to create a separatre function handle
             */
        }
    }
    
    func handle(data : Data? , response : URLResponse? , error : Error?){
        if error != nil{
            delegate?.didFailWithError(error: error!)
            return
        }
        if let safeData = data{
            if let  weather = parseJSON(weatherData: safeData){
                delegate?.didUpdateWeather(self , weather : weather)
            }
            //print(dataString as Any)
        }
    }
    func parseJSON(weatherData : Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            let description = decodedData.weather[0].description
            //print(decodedData.weather[0].description)
            let weather = WeatherModel(weatherId: id, temperature: temp, cityName: cityName, weatherDescription: description)
            return weather
            //print(weather.ConditionName)
            //print(weather.temperatureString)
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

