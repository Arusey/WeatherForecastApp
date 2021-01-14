//
//  HomeController.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import UIKit
import CoreLocation

class HomeController: UIViewController {
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCityBtn: UIButton!
    @IBOutlet weak var appInfo: UIButton!
    
    //MARK: - properties
    
    let locationManager: CLLocationManager = .init()
    let viewModel: HomeViewModel = .init()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Bookmarked Cities"
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: CityCell.className, bundle: nil), forCellReuseIdentifier: CityCell.className)
        
        addCityBtn.addTarget(self, action: #selector(self.addCityBtnTapped(sender:)), for: .touchUpInside)
        appInfo.addTarget(self, action: #selector(self.appInfoTapped(_:)), for: .touchUpInside)
    }
    
    @objc func appInfoTapped(_ sender: UIButton) {
        let appInfoVC = AppInfoController()
        self.navigationController?.pushViewController(appInfoVC, animated: true)
    }
    
    @objc func addCityBtnTapped(sender: UIButton) {
        let mapsVC = MapController()
        mapsVC.delegate = self
        
        self.navigationController?.pushViewController(mapsVC, animated: true)
    }
    
    func getLocation(location: CLLocation) {
        self.updateLocation(loc: location)
    }
    
    func updateLocation(loc: CLLocation) {
        self.viewModel.getCityByLocation(location: loc) { result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.presentAlert(title: "Alert", message: "City unavailable")
                }
            case .success(let city):
                guard let city = city else { return }
                self.viewModel.bookmarks.append(city)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    

}

extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            self.getLocation(location: location)
            self.locationManager.stopUpdatingLocation()
            
        }
    }
}



extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.className, for: indexPath) as! CityCell
        
        let data = self.viewModel.bookmarks[indexPath.row]
        cell.cityName.text = data.name
        cell.weatherTemp.text = "\(data.main.temp) ℉"
        cell.weatherStatus.text = data.weather[0].main
        return cell
        
    }
    
    
}

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.bookmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityVC = CityForeCastController()
        
        let viewModel = ForecastViewModel(cities: self.viewModel.bookmarks[indexPath.row])
        cityVC.viewModel = viewModel
        
        self.navigationController?.pushViewController(cityVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension HomeController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        self.viewModel.getCityByName(name: searchBar.text ?? "") { result in
            DispatchQueue.main.async {
                self.searchBar.text = ""
            }
            
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self.presentAlert(title: "Alert", message: "Invalid entry")
                }
            case .success(let city):
                guard let city = city else { return }
                self.viewModel.bookmarks.append(city)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
}


