//
//  LingoWordController.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 10/01/2021.
//

import Foundation

class LingoWordController : ObservableObject, LingoTextFieldSubscriber {
    
    private let solver = LingoWordSolver()
    
    @Published
    var guess: Guess = []
    
    @Published
    var answers: [Answer] = []
    
    func addLetter(_ newCharacter: Character) {
        var newLetter: Letter
        
        if let character = newCharacter.lowercased().first {
            if lastCharacter() == "i" && character == "j" {
                _ = guess.removeLast()
                newLetter = Letter.unplaced(nextId(), "ĳ")
            } else {
                newLetter = Letter.unplaced((guess.last?.id ?? -1) + 1 , character)
            }
        } else {
            newLetter = Letter.unknown((guess.last?.id ?? -1) + 1)
        }
        guess.append(newLetter)
    }
    
    private func nextId() -> Int {
        return (guess.last?.id ?? -1) + 1
    }
    
    private func lastCharacter() -> Character? {
        switch guess.last {
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
        if guess.count > 0 {
            _ = guess.removeLast()
        }
    }
}

typealias Answer = String
extension Answer: Identifiable {
    public var id: String {
        self
    }
}
