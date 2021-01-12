//
//  LingoWordController.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 10/01/2021.
//

import Foundation

class LingoWordController : ObservableObject, LingoTextFieldDelegate {

    private let solver = LingoWordSolver()
    
    @Published
    var word: Word = [] {
        didSet {
            answers = solver.solve(word)
        }
    }
    
    @Published
    var answers: [Answer] = []
    
    @Published
    var showInput: Bool = true
    
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
    
    func toggleLetter(letter: Letter) {
        switch letter {
        case .unplaced(let id, let character):
            if let index = word.firstIndex(where: { $0.id == letter.id }) {
                word[index] = .placed(id, character, index)
            }
        case .placed(let id, let character, let index):
            word[index] = .unplaced(id, character)
        default:
            break
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
    
}

typealias Answer = String
extension Answer: Identifiable {
    public var id: String {
        self
    }
}
