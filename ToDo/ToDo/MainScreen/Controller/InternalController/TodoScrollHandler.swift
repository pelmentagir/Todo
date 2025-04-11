//
//  TodoScrollHandler.swift
//  ToDo
//
//  Created by Тагир Файрушин on 10.03.2025.
//
import UIKit

class TodoScrollHandler: NSObject, UIScrollViewDelegate {
    var viewModel: ViewModel
    var todo: GeneralizedTodo
    private let maxThreshold: CGFloat = -50
    private let actionThreshold: CGFloat = -35
    var animationButton: ((Double) -> Void)?

    init(viewModel: ViewModel, todo: GeneralizedTodo) {
        self.viewModel = viewModel
        self.todo = todo
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= 0 {
            scrollView.contentOffset.x = 0
        } else if scrollView.contentOffset.x < maxThreshold {
            scrollView.contentOffset.x = maxThreshold
        }
        
        animationButton?(abs(scrollView.contentOffset.x / actionThreshold))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.x <= actionThreshold {
            viewModel.completedTodo(todo: todo)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            scrollView.setContentOffset(.zero, animated: false)
        }
    }
}
