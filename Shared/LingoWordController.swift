//
//  LingoWordController.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 10/01/2021.
//

import Foundation

class LingoWordController : ObservableObject, LingoTextFieldDelegate {

    private let minimumWordLength = 5
    
    private let solver = LingoWordSolver()
    
    @Published
    var word: Word = []
    
    @Published
    var answers: [Answer] = []
    
    func addLetter(_ newCharacter: Character) {
        var newLetter: Letter
        
        if let character = newCharacter.lowercased().first {
            if lastCharacter() == "i" && character == "j" {
                _ = word.removeLast()
                newLetter = Letter.unplaced(nextId(), "ĳ")
            } else {
                newLetter = Letter.unplaced((word.last?.id ?? -1) + 1 , character)
            }
        } else {
            newLetter = Letter.unknown((word.last?.id ?? -1) + 1)
        }
        word.append(newLetter)
    }
    
    private func nextId() -> Int {
        return (word.last?.id ?? -1) + 1
    }
    
    private func lastCharacter() -> Character? {
        switch word.last {
        case .unplaced(_, let character):
            return character
        default:
            return nil
        }
    }
    
    func onCharacterEntered(_ character: Character?) {
        if character?.isLetter == true {
            addLetter(character!)
        }
    }
    
    func onBackspacePressed() {
        if word.count > 0 {
            _ = word.removeLast()
        }
    }
    
    func shouldRelinquishFirstResponder() -> Bool {
        // TODO: Show warning/alert about not meeting requirements
        word.count >= minimumWordLength
    }
}

typealias Answer = String
extension Answer: Identifiable {
    public var id: String {
        self
    }
}
