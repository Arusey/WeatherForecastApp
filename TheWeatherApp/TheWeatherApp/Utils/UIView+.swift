//
//  UIView+.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/14/21.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, style: UIAlertController.Style = .actionSheet, action: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(action ?? defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }

}



extension UIView {
    
}
