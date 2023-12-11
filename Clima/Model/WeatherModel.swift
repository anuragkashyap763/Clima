//
//  WeatherModel.swift
//  Clima
//
//  Created by ANURAG KASHYAP on 17/11/23.

//

import Foundation
struct WeatherModel{
    let weatherId : Int
    let temperature : Double
    let cityName : String
    let weatherDescription : String
    
    var temperatureString : String{
        return String(format: "%0.1f",temperature)
    }
    
    var ConditionName : String {
        switch weatherId {
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
}
