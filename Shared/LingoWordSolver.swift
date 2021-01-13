//
//  LingoWordSolver.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 09/01/2021.
//

import Foundation

struct LingoWordSolver {
    static let regularWordLengths = [5, 6, 7, 8]
    static let puzzleWordLengths = [11, 12, 13]
    static let wordLengths = regularWordLengths + puzzleWordLengths
    
    private let candidateLists: [Int: [String]]
    
    init() {
        candidateLists = Dictionary(uniqueKeysWithValues: LingoWordSolver.wordLengths.map { wordLength in
            let fileName = Bundle.main.path(forResource: String(describing: wordLength), ofType: "txt")
            let contents = try! String(contentsOfFile: fileName!, encoding: String.Encoding.utf8)
            let lines = contents.components(separatedBy: "\n")
            return (wordLength, lines)
        })
    }
    
    func solve(word: [Letter]) -> [String] {
        if LingoWordSolver.regularWordLengths.contains(word.count) {
            return solveRegular(word: word)
        } else if LingoWordSolver.puzzleWordLengths.contains(word.count) {
            return solvePuzzle(word: word)
        } else {
            return []
        }
    }

    func solveRegular(word: [Letter]) -> [String] {
        let unplacedCharacters = word.unplacedLetters.characters
        let incorrectCharacters = word.incorrectLetters.characters
        let placedCharacters = word.placedLetters.characters
        return candidateLists[word.count]?.filter { candidate in
            zip(word, candidate).allSatisfy { letter, character in
                switch letter.status {
                case .placed: // Must be this character in this place
                    return letter.character == character
                case .unplaced: // Must be this character but not this place
                    return letter.character != character
                case .incorrect: // Can not be this character
                    return letter.character != character
                case .unknown: // Can be any character
                    return true
                }
            }
        }.filter { candidate in
            // All unplaced characters appear exactly once among non-placed characters
            // All incorrect characters do not appear among non-placed characters
            let nonPlacedCharacters = candidate.drop { character in
                placedCharacters.contains(character) || incorrectCharacters.contains(character)
            }
            return unplacedCharacters.allAppearOnce(in: Array(nonPlacedCharacters)) && incorrectCharacters.allSatisfy { incorrectCharacter in
                !nonPlacedCharacters.contains(incorrectCharacter)
            }
        } ?? []
    }

    func solvePuzzle(word: [Letter]) -> [String] {
        let unplacedCharacters = word.unplacedLetters.characters
        return candidateLists[word.count]?.filter { candidate in
            zip(word, candidate).allSatisfy { letter, character in
                switch letter.status {
                case .placed: // Must be this character in this place
                    return letter.character == character
                case .unplaced, .incorrect, .unknown: // Not applicable
                    return true
                }
            }
        }.filter { candidate in
            // All unplaced characters appear exactly once
            unplacedCharacters.allAppearOnce(in: Array(candidate))
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
