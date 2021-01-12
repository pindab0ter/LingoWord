//
//  LingoWordSolver.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 09/01/2021.
//

import Foundation

struct LingoWordSolver {
    static let allowedWordLengths = [5, 6, 7, 11, 12, 13]
    
    private let candidateLists: [Int: [String]]
    
    init() {
        candidateLists = Dictionary(uniqueKeysWithValues: LingoWordSolver.allowedWordLengths.map { wordLength in
            let fileName = Bundle.main.path(forResource: String(describing: wordLength), ofType: "txt")
            let contents = try! String(contentsOfFile: fileName!, encoding: String.Encoding.utf8)
            let lines = contents.components(separatedBy: "\n")
            return (wordLength, lines)
        })
    }
    
    func solve(_ word: [Letter]) -> [String] {
        if LingoWordSolver.allowedWordLengths.contains(word.count) {
            if let candidates = candidateLists[word.count] {
                return candidates.enumerated().filter { index, candidate in
                    candidate.count == word.count
                        && word.incorrectLetters.characters.allSatisfy { incorrectLetter in !candidate.contains(incorrectLetter) }
                        && word.validLetters.characters.allAppearOnce(in: Array(candidate))
                        && word.placedLetters.allSatisfy { placedLetter in
                            if let index = word.firstIndex(where: { letter in letter.id == placedLetter.id }) {
                                return candidate[candidate.index(candidate.startIndex, offsetBy: index)] == placedLetter.character!
                            } else {
                                return false
                            }
                        }
                }.map { _, element in element }
            }
        }
        return []
    }
}

enum Letter: Identifiable {
    case placed(Int, Character)
    case unplaced(Int, Character)
    case incorrect(Int, Character)
    case unknown(Int)
    
    var id: Int {
        switch self {
        case .placed(let id, _):
            return id
        case .unplaced(let id, _):
            return id
        case .incorrect(let id, _):
            return id
        case .unknown(let id):
            return id
        }
    }
    var character: Character? {
        switch self {
        case .placed(_, let character):
            return character
        case .unplaced(_, let character):
            return character
        case .incorrect(_, let character):
            return character
        case .unknown(_):
            return nil
        }
    }
}

typealias PlacedLetter = (Character, Int)

extension Array where Element == Letter {
    var placedLetters: [Letter] {
        return compactMap { letter in
            switch letter {
            case .placed:
                return letter
            default:
                return nil
            }
        }
    }
    var unplacedLetters: [Letter] {
        return compactMap { letter in
            switch letter {
            case .unplaced:
                return letter
            default:
                return nil
            }
        }
    }
    var incorrectLetters: [Letter] {
        return compactMap { letter in
            switch letter {
            case .incorrect:
                return letter
            default:
                return nil
            }
        }
    }
    var validLetters: [Letter] {
        return placedLetters + unplacedLetters
    }
    var characters: [Character] {
        return compactMap { letter in letter.character }
    }
}

extension Array where Element : Comparable {
    func allAppearOnce(in collection: [Element]) -> Bool {
        var uncheckedElements = collection
        for element in self {
            if uncheckedElements.contains(element) {
                uncheckedElements.remove(at: uncheckedElements.firstIndex(of: element)!)
            } else {
                return false
            }
        }
        return true
    }
}
