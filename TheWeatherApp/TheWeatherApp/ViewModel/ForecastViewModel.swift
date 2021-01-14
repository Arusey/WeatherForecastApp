//
//  ForecastViewModel.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import Foundation


class ForecastViewModel {
    
    var weatherForecast: WeatherResponse?
    let cities: CitiesResponse?
    
    
    init(cities: CitiesResponse) {
        self.cities = cities
    }
    
    func getWeatherForecast(completion: @escaping (Result<WeatherResponse?, Error>) -> Void) {
        
        let semaphore = DispatchSemaphore (value: 0)
        guard let latitude = cities?.coord.lat else { return }
        guard let longitude = cities?.coord.lon else { return }

        var request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=5&appid=c6e381d8c7ff98f0fee43775817cf6ad")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
                
            else if let data = data {
                let forecast = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                self.weatherForecast = forecast
                completion(.success(forecast))
            }
            

          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
}
