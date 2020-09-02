//
//  WeatherModel.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 21.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}

struct Current: Decodable {
    let temp: Double
    let pressure: Int
    let humidity: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
}

struct Hourly: Decodable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct Daily: Decodable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

struct Temp: Decodable {
    let day: Double
}

struct Weather: Decodable {
    let description: String
    let icon: String
}
