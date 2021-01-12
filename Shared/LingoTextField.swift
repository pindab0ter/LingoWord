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
        var delegate: LingoTextFieldDelegate? = nil
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
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            let relinquishFirstResponder = delegate?.shouldRelinquishFirstResponder() == true
            becameFirstResponder = relinquishFirstResponder
            if relinquishFirstResponder {
                return textField.resignFirstResponder()
            } else {
                return false
            }
        }
        
        func notifyCharacterEntered(character: Character?) {
            delegate?.onCharacterEntered(character)
        }
        
        func notifyBackspacePressed() {
            delegate?.onBackspacePressed()
        }
    }
    
    func assign(delegate: LingoTextFieldDelegate) -> LingoTextField {
        coordinator.delegate = delegate
        return self
    }
    
    func makeCoordinator() -> Coordinator {
        return coordinator
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
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

protocol LingoTextFieldDelegate {
    func onCharacterEntered(_ character: Character?)
    func onBackspacePressed()
    func shouldRelinquishFirstResponder() -> Bool
}
