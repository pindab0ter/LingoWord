//
//  Letter.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 13/01/2021.
//

struct Letter: Identifiable {
    var id: Int
    var status: Status
    var character: Character? = nil
    
    enum Status {
        case placed, unplaced, incorrect, unknown
    }
}

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
