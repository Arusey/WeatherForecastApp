//
//  HomeViewModel.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import Foundation
import CoreLocation

class HomeViewModel {
    
    var getCity: String = ""
    var cityLocation: CLLocation?
    var bookmarks: [CitiesResponse] = []
    
    func getCityByName(name: String, completion: @escaping (Result<CitiesResponse?, Error>) -> Void) {
        
        
        guard let string = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(name.replacingOccurrences(of: " ", with: ""))&appid=c6e381d8c7ff98f0fee43775817cf6ad") else { return }
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: string, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let citiesResponse = try JSONDecoder().decode(CitiesResponse.self, from: data)
                    completion(.success(citiesResponse))
                }
                catch {
                    completion(.failure(NSError(domain: "Invalid City", code: 400, userInfo: nil)))
                }
                catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    //                            completion(.failure(error))
                }
            }
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
    }
    
    func getCityByLocation(location: CLLocation, completion: @escaping (Result<CitiesResponse?, Error>) -> Void) {
        
        if let locale = self.cityLocation {
            guard locale.coordinate.latitude != location.coordinate.latitude && locale.coordinate.longitude != location.coordinate.longitude else { return }
        }
        
        self.cityLocation = location
        
        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&cnt=5&appid=c6e381d8c7ff98f0fee43775817cf6ad")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let citiesResponse = try JSONDecoder().decode(CitiesResponse.self, from: data)
                    completion(.success(citiesResponse))
                }
                
                
                catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    completion(.failure(NSError(domain: "Invalid Entry", code: 400, userInfo: nil)))
                }
            }
            
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        
    }
    
    
    
    
    
}
