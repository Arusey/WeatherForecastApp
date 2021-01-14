//
//  CityForeCastController.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import UIKit

class CityForeCastController: UIViewController {
    
    
    
    var viewModel: ForecastViewModel?
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let layout: UICollectionViewFlowLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: WeekTempCell.className, bundle: nil), forCellWithReuseIdentifier: WeekTempCell.className)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: WeatherStatusCell.className, bundle: nil), forCellReuseIdentifier: WeatherStatusCell.className)
        
    }
    
    
    func loadData() {
        
        if let city = self.viewModel?.cities {
            cityName.text = city.name
            cityTemperature.text = "\(Int(city.main.temp)) ℉"
        }
        
        self.viewModel?.getWeatherForecast(completion: { result in
            switch result {
            case .failure(let error):
                self.presentAlert(title: "Alert", message: error.localizedDescription)
            case.success(let response):
                self.viewModel?.weatherForecast = response
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                }
            }
        })
        
    }


}

extension CityForeCastController: UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vModel = self.viewModel, let weatherForecast = vModel.weatherForecast else { return .init() }
        
        
        let weatherCount = weatherForecast.list[0].descriptions
        return weatherCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let vModel = self.viewModel, let weatherForecast = vModel.weatherForecast else { return .init() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherStatusCell.className, for: indexPath) as! WeatherStatusCell
        
        let data = weatherForecast.list[indexPath.row]
        cell.humidity.text = "\(data.humidity) %"
        cell.windStatus.text = "\(data.speed)"
        cell.rainChances.text = data.weather[0].weatherDescription
        return cell
    }
    
    
}


extension CityForeCastController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


extension CityForeCastController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        let weatherForecast = self.viewModel?.weatherForecast
        guard let statusCount = weatherForecast?.list[0].descriptions.count else { return 0 }
        return statusCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let vModel = self.viewModel, let weatherForecast = vModel.weatherForecast else { return .init() }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekTempCell.className, for: indexPath) as! WeekTempCell
        
        let weatherData = weatherForecast.list[indexPath.row]
        let date = Date(timeIntervalSince1970: Double(weatherData.dt))
        cell.temperature.text = "\(weatherData.temp.day) ℉"
        cell.timeofDay.text = "\(Date.formatDate(date: date))"
        
        return cell
        
        
    }

    
    
}


extension CityForeCastController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let vModel = self.viewModel, let weatherForecast = vModel.weatherForecast else { return .init() }
        
        let statusCount = weatherForecast.list[0].descriptions.count
        return CGSize(width: ((collectionView.bounds.width - 10) / CGFloat(statusCount)), height: (collectionView.bounds.height - 5))

        
    }
}
