//
//  LingoWordSolver.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 09/01/2021.
//

import Foundation

struct LingoWordSolver {
    // TODO: Load each word length in separate array/map entry
    private let words: [String]
    
    init() {
        let fileName = Bundle.main.path(forResource: "wordlist", ofType: "txt")
        let contents = try! String(contentsOfFile: fileName!, encoding: String.Encoding.utf8)
        words = contents.components(separatedBy: "\n")
    }
    
    func solve(_ guess: Guess) -> [String] {
        words.filter { word in
            // TODO: Prevent reusing letters
            word.count == guess.count
                && guess.incorrectLetters.allSatisfy { incorrectLetter in !word.contains(incorrectLetter) }
                && guess.unplacedLetters.allSatisfy { unplacedLetter in word.contains(unplacedLetter) }
                && guess.placedLetters.allSatisfy { (letter, index) in
                    word[word.index(word.startIndex, offsetBy: index)] == letter
                }
        }
    }
}

enum Letter: Identifiable {
    case placed(Int, Character, Int)
    case unplaced(Int, Character)
    case incorrect(Int, Character)
    case unknown(Int)

    var id: Int {
        switch self {
        case .placed(let id, _, _):
            return id
        case .unplaced(let id, _):
            return id
        case .incorrect(let id, _):
            return id
        case .unknown(let id):
            return id
        }
    }
}

typealias Guess = [Letter]
typealias PlacedLetter = (Character, Int)

extension Guess {
    var placedLetters: [PlacedLetter] {
        return compactMap { letter in
            switch letter {
            case .placed(_, let character, let index):
                return (character, index)
            default:
                return nil
            }
        }
    }
    var unplacedLetters: [Character] {
        return compactMap { letter in
            switch letter {
            case .unplaced(_, let character):
                return character
            default:
                return nil
            }
        }
    }
    var incorrectLetters: [Character] {
        return compactMap { letter in
            switch letter {
            case .incorrect(_, let character):
                return character
            default:
                return nil
            }
        }
    }
}
