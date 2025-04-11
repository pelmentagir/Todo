//
//  IconColorManager.swift
//  ToDo
//
//  Created by Тагир Файрушин on 22.03.2025.
//

import Foundation
import UIKit

class IconColorManager {
    static let shared = IconColorManager()
    
    private let colorKey = "iconColor"
    
    private init() { }
    
    var currentColor: UIColor {
        get {
            if let data = UserDefaults.standard.data(forKey: self.colorKey),
               let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
                return color
            }
            return .systemBlue
        }
        
        set {
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false) {
                UserDefaults.standard.set(data, forKey: colorKey)
            }
            NotificationCenter.default.post(name: .iconColorChange, object: nil)
        }
    }
}
