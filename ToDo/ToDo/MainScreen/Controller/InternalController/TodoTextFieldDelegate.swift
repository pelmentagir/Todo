//
//  TodoTextFieldDelegate.swift
//  ToDo
//
//  Created by Тагир Файрушин on 10.03.2025.
//

import UIKit

class TodoTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var viewModel: MainViewModel
    private var todo: Todo
    
    init(viewModel: MainViewModel, todo: Todo) {
        self.viewModel = viewModel
        self.todo = todo
        super.init()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel.changeKeyboardStateEdittingStyle()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            viewModel.editTodo(todo: todo, newText: textField.text!)
            viewModel.changeKeyboardStateEdittingStyle()
            textField.endEditing(true)
        }
        return true
    }
}

