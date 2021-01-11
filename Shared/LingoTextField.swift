//
//  FirstResponderTextField.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 11/01/2021.
//

import SwiftUI

struct LingoTextField : UIViewRepresentable {

    private var coordinator = Coordinator()
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var becameFirstResponder = false
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string == "" {
                notifyBackspacePressed()
            } else {
                notifyCharacterEntered(character: string.first)
            }
            textField.text = "." // Enable backspace detection
            return false
        }
        
        var subscribers: [LingoTextFieldSubscriber] = []
        
        func notifyCharacterEntered(character: Character?) {
            subscribers.forEach { subscriber in
                subscriber.onCharacterEntered(character)
            }
        }
        
        func notifyBackspacePressed() {
            subscribers.forEach { subscriber in
                subscriber.onBackspacePressed()
            }
        }
    }
    
    func subscribe(subscriber: LingoTextFieldSubscriber) -> LingoTextField {
        coordinator.subscribers.append(subscriber)
        return self
    }
    
    func makeCoordinator() -> Coordinator {
        return coordinator
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}

protocol LingoTextFieldSubscriber {
    func onCharacterEntered(_ character: Character?)
    func onBackspacePressed()
}
