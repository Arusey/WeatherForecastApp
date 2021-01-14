//
//  TheWeatherAppTests.swift
//  TheWeatherAppTests
//
//  Created by Kevin Lagat on 1/14/21.
//

import XCTest
import CoreLocation
@testable import TheWeatherApp

class TheWeatherAppTests: XCTestCase {
    
    var viewModel = HomeViewModel()
    var weatherVM: ForecastViewModel?
    
    let location = CLLocation(latitude: 36.8167, longitude: -1.2833)
    
    override func setUp() {
        viewModel.getCityByName(name: "Nairobi") { result in
            switch result {
            case .success(let city):
                if let city = city {
                    self.weatherVM = ForecastViewModel(cities: city)
                    self.viewModel.bookmarks.append(city)
                }
            case .failure: XCTFail()
            }
        }
        
        viewModel.getCityByLocation(location: location) { result in
            switch result {
            case .failure: XCTFail()
            case .success(let city):
                if let city = city {
                    self.weatherVM = ForecastViewModel(cities: city)
                    self.viewModel.bookmarks.append(city)
                }
            }
        }
    }
    
    func testGetCityByName() {
        viewModel.getCityByName(name: "Nairobi") { result in
            switch result {
            case .failure: XCTFail()
            case .success:
                XCTAssertEqual(self.viewModel.bookmarks.count, 1, "passed")
            }
        }
    }
    
    func testGetCityByLocation() {
        viewModel.getCityByLocation(location: location) { result in
            switch result {
            case .failure: XCTFail()
            case .success:
                XCTAssertEqual(self.viewModel.bookmarks.count, 1, "passed")
            }
        }
    }
    
    func testGetWeatherForecast() {
        
        guard let vModel = weatherVM else {
            XCTFail()
            return }
        weatherVM?.getWeatherForecast() { result in
            switch result {
            case .failure: XCTFail()
            case .success(let weatherForecast):
                XCTAssertEqual(vModel.weatherForecast?.city.id, weatherForecast?.city.id, "passed")
            }
        }
    }
    
    
    

}
