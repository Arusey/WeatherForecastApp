//
//  WeatherResponse.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import Foundation

struct WeatherResponse: Codable {
    let city: City
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone: Int
}


// MARK: - List
struct List: Codable {
    let dt, sunrise, sunset: Int
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let weather: [Weather]
    let speed: Double
    let deg, clouds: Int
    let pop: Double
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity, weather, speed, deg, clouds, pop, rain
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}

extension List {
    var descriptions: [String: Any] {
        [
            "Humidity": self.humidity,
            "Rain Chances": self.weather[0].weatherDescription,
            "Wind Speed": self.speed
        ]
    }
}
