//
//  ClassNameProtocol.swift
//  TheWeatherApp
//
//  Created by Kevin Lagat on 1/18/21.
//

import Foundation
import UIKit

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}

extension UIViewController: ClassNameProtocol {}
extension UIView: ClassNameProtocol {}
