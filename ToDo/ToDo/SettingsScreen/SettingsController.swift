//
//  SettingsController.swift
//  ToDo
//
//  Created by Тагир Файрушин on 18.03.2025.
//
import UIKit

class SettingsController: UIViewController {

    private var settingView: SettingsView {
        self.view as! SettingsView
    }
    
    private lazy var pushChangeColorView = UIAction { [weak self] _ in
        guard let self else { return }
        let changeColorView = ChangeColorController()
        changeColorView.modalTransitionStyle = .coverVertical
        changeColorView.modalPresentationStyle = .custom
        changeColorView.transitioningDelegate = self
        changeColorView.onDismiss = {
            self.dismiss(animated: true)
        }
        
        present(changeColorView, animated: true)
    }
    
    private lazy var toogleTheme = UIAction { [weak self] _ in
        guard let self else { return }
        let currentTheme = traitCollection.userInterfaceStyle
        let newTheme: UIUserInterfaceStyle = currentTheme == .dark ? .light : .dark
        
        ThemeManager.shared.setTheme(newTheme)
        
        self.dismiss(animated: true) {
            if let window = UIApplication.shared.windows.first {
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.overrideUserInterfaceStyle = newTheme
                })
            }
        }
    }
    
    override func loadView() {
        self.view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActionForButton()
    }
    
    private func setupActionForButton() {
        settingView.accentColorButton.addAction(pushChangeColorView, for: .touchUpInside)
        settingView.colorSchemeButton.addAction(toogleTheme, for: .touchUpInside )
    }
}

extension SettingsController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomHeightPresentationController(presentedViewController: presented, presenting: presenting, customHeigth: UIScreen.main.bounds.height*0.25)
    }
}
