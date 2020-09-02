//
//  WeatherViewModel.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 21.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import UIKit

struct WeatherViewModel {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

// MARK: - Current

extension WeatherViewModel {

    var currentTemperature: String {
        return String(Int(current.temp)) + "°"
    }

    var icon: UIImage {
        guard let iconName = current.weather.first?.icon else { return UIImage() }
        return fetchWeatherIcon(iconName)
    }

    var description: String {
        guard let description = current.weather.first?.description else { return "" }
        return description.capitalizingFirstLetter()
    }
}

// MARK: - Hourly

extension WeatherViewModel {
    
    /*
    var hourlyIcons: [UIImage] {
        /*
        let cutValues = hourly.prefix(7)
        let hourlyValues = cutValues.flatMap { $0.weather.map { $0.icon } }
        print(hourlyValues)
        */
        
        
        // return hourlyValues.map { fetchWeatherIcon($0) }
        // Array(repeating: UIImage(), count: 7)
        // hourly.map { fetchWeatherIcon($0.weather.first!.icon) }
    }*/
    
    var hourlyTemperatures: [String] {
        return hourly.map { String(Int($0.temp)) + "°" }
    }
    
    func hourlyIconImage(_ index: Int) -> UIImage {
        let cutValues = hourly.prefix(7)
        let hourlyValues = cutValues.flatMap { $0.weather.map { $0.icon } }
        let icon = fetchWeatherIcon(hourlyValues[index])
        return icon
    }
    
    /*
    var maxHourlyTemperature: CGFloat {
        let values = hourly.map { $0.temp }
        return CGFloat(values.max() ?? 0)
    }
    
    var hourlyTempDouble: [CGFloat] {
        return hourly.map { CGFloat($0.temp) }
    }
    */
    
    var numOfHours: Int {
        return 7 // hourly.count
    }
    
    var heightByTemperature: [CGFloat] {
        let htValues = hourly.map { $0.temp }
        let maxValue = htValues.max()!
        return htValues.map { CGFloat(maxValue - $0) * 2 }
    }
    
    var hours: [String] {
        return hourly.map { unixDateToDateString(unixDate: Double($0.dt), format: "HH:mm") }
    }
}

// MARK: - Daily

extension WeatherViewModel {
    
    var days: [String] {
        return daily.map { unixDateToDateString(unixDate: Double($0.dt), format: "EEE, dd MMMM") }
    }

    var dailyTemperatures: [String] {
        return daily.map { String(Int($0.temp.day)) + "°" }
    }
    
    var numOfDays: Int {
        return daily.count
    }

    /*
    var icons: [UIImage] {
        var counter = 1
        print(counter+=1)
        return daily.map { fetchWeatherIcon($0.weather.first!.icon) }
    }
    */
    
    func dailyIconImage(_ index: Int) -> UIImage {
        
        let dailyValues = daily.flatMap { $0.weather.map { $0.icon } }
        let icon = fetchWeatherIcon(dailyValues[index])
        print(icon)
        return icon
        // return UIImage()
    }
}

// MARK: - Detailed

extension WeatherViewModel {
    
    var pressure: String {
        return String(Int(Double(current.pressure) / 1.333)) + " мм рт. ст."
    }

    var humidity: String {
        return String(current.humidity) + "%"
    }

    var windSpeed: String {
        return String(current.wind_speed) + " м/с, " + degreeToWindDirection(current.wind_deg)
    }
    
    func degreeToWindDirection(_ degree: Int) -> String {
        switch degree {
        case 0...23, 337...360: return "С"
        case 24...68: return "С-В"
        case 69...113: return "В"
        case 114...158: return "Ю-В"
        case 159...203: return "Ю"
        case 204...248: return "Ю-З"
        case 249...293: return "З"
        case 294...336: return "С-З"
        default: return ""
        }
    }

    var degree: Int {
        return current.wind_deg
    }
}

// MARK: - Methods

extension WeatherViewModel {
    
    private func fetchWeatherIcon(_ iconName: String) -> UIImage {
        let urlString = "http://openweathermap.org/img/wn/\(iconName)@2x.png"
        guard let url = URL(string: urlString) else { return UIImage() }
        guard let data = try? Data(contentsOf: url) else { return UIImage() }
        guard let iconImage = UIImage(data: data) else { return UIImage() }
        return iconImage
    }

    func unixDateToDateString(unixDate: Double, format: String) -> String {
        let date = Date(timeIntervalSince1970: unixDate)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru-RU")
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
