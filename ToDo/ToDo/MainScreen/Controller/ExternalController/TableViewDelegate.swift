//
//  TableViewDelegate.swift
//  ToDo
//
//  Created by Тагир Файрушин on 03.02.2025.
//

import Foundation
import UIKit

class TableViewDelegate: NSObject, UITableViewDelegate, UITextFieldDelegate {

    private lazy var createTodoHeader = HeaderCreateTodoTableSection()
    
    lazy var sooner = HeaderTableViewSection(iconImage: UIImage(systemName: "note")!, title: "Soon")
    lazy var later = HeaderTableViewSection(iconImage: UIImage(systemName: "note.text")!, title: "Later")
    
    private var viewModel: MainViewModel
    
    var headerGesture: ((StateGesture) -> Void)?
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        
        super.init()
        configureHeaderCreateTodo()
        configureHeaderLater()
        bingingUpdataCounterTask()
    }
    
    private func configureHeaderLater() {
        later.scrollView.alwaysBounceVertical = true
        later.scrollView.delegate = self
    }
    
    private func configureHeaderCreateTodo() {
        createTodoHeader.setupTextFieldDelegate(self)
    }
    
    func updateColor() {
        sooner.updateColor()
        later.updateColor()
        sooner.setNeedsDisplay()
        later.setNeedsDisplay()
    }
    
    func animateButton(_ type: HeaderType, soonerHeight: CGFloat, laterHeight: CGFloat) {
        
        let isSoonExpanded = soonerHeight > laterHeight
        let isLaterExpanded = laterHeight > soonerHeight
        
        let activeButton = type == .soon ? self.sooner.rectangleButton : self.later.rectangleButton
        let inactiveButton = type == .soon ? self.later.rectangleButton : self.sooner.rectangleButton
        let isExpanded = type == .soon ? isSoonExpanded : isLaterExpanded
     
        UIView.animate(withDuration: 0.3) {
            activeButton.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            activeButton.setImage(UIImage(systemName: isExpanded ? "rectangle.compress.vertical" : "rectangle.expand.vertical"), for: .normal)
            
            inactiveButton.transform = .identity
            inactiveButton.setImage(UIImage(systemName: "rectangle.expand.vertical"), for: .normal)
        }
    }
    
    // MARK: ScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -10 {
            scrollView.contentOffset.y = -10
        } else if scrollView.contentOffset.y > 10 {
            scrollView.contentOffset.y = 10
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let y = scrollView.contentOffset.y
        if y >= 10 || y <= -10 {
            let stateGesture: StateGesture = y >= 10 ? .up : .down
            self.headerGesture?(stateGesture)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                scrollView.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    // MARK: TableViewDelegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if viewModel.keyboardState {
                return createTodoHeader
            } else {
                return sooner
            }
        case 1:
            return later
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constant.TableViewSize.headerHeight
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow(section: indexPath.section)
    }
    
    func bingingUpdataCounterTask() {
        viewModel.counterTask = { [weak self] count, section in
            guard let self else { return }
            let header = section == .soon ? sooner : later
            header.counterTask.updateCount(String(count))
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updateText = text.replacingCharacters(in: textRange, with: string)
            let icon = createTodoHeader.iconImage
            if updateText.count > text.count {
                icon.alpha += 0.25
            } else {
                icon.alpha -= 0.25
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            let todo = Todo(title: text, section: .soon)
            viewModel.appendTodoBySection(todo, section: .soon)
            createTodoHeader.iconImage.alpha = 0.25
            textField.text = ""
            viewModel.changeKeyboardState()
        }
        return true
    }
}
