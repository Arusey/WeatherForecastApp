//
//  MapController.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import UIKit
import MapKit

protocol MapControllerDelegate: class {
    func locationTapped(_ location: CLLocation)
}

class MapController: UIViewController {
    
    var delegate: MapControllerDelegate?
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tap)
        
    }
        
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.mapView)
        let location = mapView.convert(point, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.locationTapped(CLLocation(latitude: location.latitude, longitude: location.longitude))
        }

    }

}

extension MapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}

extension HomeController: MapControllerDelegate {
    func locationTapped(_ location: CLLocation) {
        self.getLocation(location: location)
    }
    
    
}
