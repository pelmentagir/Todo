import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {}
    
    func setTheme(_ style: UIUserInterfaceStyle) {
        // Сохраняем настройку в UserDefaults
        UserDefaults.standard.set(style == .dark, forKey: "isDarkMode")
        
        // Применяем тему ко всем окнам приложения
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { window in
                window.overrideUserInterfaceStyle = style
            }
    }
    
    func getCurrentTheme() -> UIUserInterfaceStyle {
        return UserDefaults.standard.bool(forKey: "isDarkMode") ? .dark : .light
    }
} 