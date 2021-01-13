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
    var word: [Letter] = [] {
        didSet {
            answers = solver.solve(word: word)
        }
    }
    
    @Published
    var answers: [Answer] = []
    
    @Published
    var showInput: Bool = true
    
    func add(_ character: Character) {
        if word.last?.character?.lowercased() == "i" && character.lowercased() == "j" {
            _ = word.removeLast()
            word.append(Letter(id: nextId(), status: character.isUppercase ? .placed : .unplaced, character: "ĳ"))
        } else if character == "." || character == " " {
            word.append(Letter(id: nextId(), status: .unknown))
        } else {
            word.append(Letter(id: nextId(), status: character.isUppercase ? .placed : .unplaced, character: character))
        }
    }
    
    func toggleLetter(letter: Letter) {
        if let index = word.firstIndex(where: { $0.id == letter.id }) {
            switch letter.status {
            case .unplaced:
                word[index].status = .placed
            case .placed:
                word[index].status = .incorrect
            case .incorrect:
                word[index].status = .unplaced
            default:
                break
            }
        }
    }

    func onCharacterEntered(_ character: Character?) {
        if (character?.isLetter == true && character?.isASCII == true) || character == "." || character == " " {
            add(character!)
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
}

typealias Answer = String
extension Answer: Identifiable {
    public var id: String {
        self
    }
}
