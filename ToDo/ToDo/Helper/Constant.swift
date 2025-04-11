//
//  Constant.swift
//  ToDo
//
//  Created by Тагир Файрушин on 03.02.2025.
//

import Foundation
import UIKit

struct Constant {
    struct Constraints {
        static let small: CGFloat = 5
        static let medium: CGFloat = 10
        static let big: CGFloat = 15
        static let large: CGFloat = 20
        static let xlarge: CGFloat = 25
    }
    
    struct TableViewSize {
        static let headerHeight: CGFloat = 56
        static let zeroHeight: CGFloat = 0
        static let defaultHeight: CGFloat = (UIScreen.main.bounds.height - UIInsets.topInset - UIInsets.bottomInset - UIElementSize.toolbarHeight - headerHeight * 2) / 2
        static let defaultHeightOnKeyboard: CGFloat = defaultHeight / 2
        static let fullScreenHeightOnKeyboard: CGFloat = defaultHeightOnKeyboard * 2
        static let fullScreenHeight: CGFloat = defaultHeight * 2
    }
    
    struct UIElementSize {
        static let toolbarHeight: CGFloat = 44
    }
    
    struct UIInsets {
        static var topInset: CGFloat {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow }) else {
                return 0
            }
            return window.safeAreaInsets.top
        }
        
        static var bottomInset: CGFloat {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?
                .windows
                .first(where: { $0.isKeyWindow }) else {
                return 0
            }
            return window.safeAreaInsets.bottom
        }
    }
    
    enum BarMarkSize {
        case withTimeRange(TimeRange)
        
        var getVal: CGFloat {
            switch self {
            case .withTimeRange(let timeRange):
                switch timeRange {
                case .day:
                    return UIScreen.main.bounds.width / 40
                case .week:
                    return UIScreen.main.bounds.width / 10
                case .month:
                    return UIScreen.main.bounds.width / 40
                }
            }
        }
    }
}
