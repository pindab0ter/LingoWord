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
        guard LingoWordSolver.allowedWordLengths.contains(word.count) else {
            return []
        }

        let unplacedCharacters = word.unplacedLetters.characters
        let incorrectCharacters = word.incorrectLetters.characters
        return candidateLists[word.count]?.filter { candidate in
            zip(word, candidate).allSatisfy { letter, character in
                switch letter.status {
                case .placed:
                    return letter.character == character
                case .unplaced:
                    return letter.character != character || unplacedCharacters.reduce(0) { acc, character in
                        letter.character == character ? acc + 1 : 0
                     } > 1
                case .incorrect:
                    return letter.character != character
                case .unknown:
                    return true
                }
            }
        }.filter { candidate in
            unplacedCharacters.allAppearOnce(in: Array(candidate)) && incorrectCharacters.allSatisfy { incorrectCharacter in
                !candidate.contains(incorrectCharacter)
            }
        } ?? []
    }
}

struct Letter: Identifiable {
    var id: Int
    var status: Status
    var character: Character? = nil
    
    enum Status {
        case placed, unplaced, incorrect, unknown
    }
}

typealias PlacedLetter = (Character, Int)

extension Array where Element == Letter {
    var placedLetters: [Letter] {
        return compactMap { letter in
            letter.status == .placed ? letter : nil
        }
    }
    var unplacedLetters: [Letter] {
        return compactMap { letter in
            letter.status == .unplaced ? letter : nil
        }
    }
    var incorrectLetters: [Letter] {
        return compactMap { letter in
            letter.status == .incorrect ? letter : nil
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
