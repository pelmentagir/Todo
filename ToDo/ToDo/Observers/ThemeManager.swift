//
//  ThemeManager.swift
//  ToDo
//
//  Created by Тагир Файрушин on 24.03.2025.
//

import Foundation
import UIKit

class ThemeManager {
    
    static let shared = ThemeManager()
    private let themeKey = "selectedTheme"
    
    private init() {}
    
    enum Theme: String {
        case light
        case dark
    }
    
    var currentTheme: Theme {
        get {
            let currentTheme = UserDefaults.standard.string(forKey: themeKey) ?? Theme.light.rawValue
            return Theme(rawValue: currentTheme) ?? .light
        }
        
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            applyTheme(newValue)
        }
    }
    
    func setTheme(_ style: UIUserInterfaceStyle) {
        let theme: Theme = style == .dark ? .dark : .light
        currentTheme = theme
    }
    
    func applyTheme(_ theme: Theme) {
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
        
        windows.forEach { window in
            window.overrideUserInterfaceStyle = theme == .dark ? .dark : .light
        }
        
        if let window = windows.first(where: { $0.isKeyWindow }) {
            updateThemeForVisibleControllers(in: window.rootViewController, theme: theme)
        }
    }
    
    private func updateThemeForVisibleControllers(in viewController: UIViewController?, theme: Theme) {
        guard let viewController = viewController else { return }
        
        viewController.overrideUserInterfaceStyle = theme == .dark ? .dark : .light
        
        if let presented = viewController.presentedViewController {
            updateThemeForVisibleControllers(in: presented, theme: theme)
        }
        
        if let navigationController = viewController as? UINavigationController {
            navigationController.viewControllers.forEach { vc in
                updateThemeForVisibleControllers(in: vc, theme: theme)
            }
        }
        
        if let tabBarController = viewController as? UITabBarController {
            tabBarController.viewControllers?.forEach { vc in
                updateThemeForVisibleControllers(in: vc, theme: theme)
            }
        }
    }
}
