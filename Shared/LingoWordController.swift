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
    /*var guess = (0..<11).map { index in
        Letter.unknown(index)
    }*/
    /*var guess: Guess = [
        .unplaced(0, "i"),
        .unplaced(1, "k"),
        .unplaced(2, "o"),
        .unplaced(3, "s"),
        .placed(4, "t", 4), // TODO: Remove redundant "position"
        .unplaced(5, "f"),
        .placed(6, "b", 6),
        .unplaced(7, "a"),
        .unplaced(8, "e"),
        .unplaced(9, "r"),
        .unplaced(10, "r")
    ] {
        didSet {
            answers = solver.solve(guess)
        }
    }*/
    
    @Published
    var answers: [Answer] = []
    
    func addLetter(_ newCharacter: Character?) {
        var newLetter: Letter
        
        if let character = newCharacter?.lowercased().first {
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
    
    func onCharacterEntered(_ character: Character) {
        addLetter(character)
    }
}

typealias Answer = String
extension Answer: Identifiable {
    public var id: String {
        self
    }
}
