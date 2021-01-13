//
//  Helpers.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 13/01/2021.
//

import SwiftUI

func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * 4/5
}

func radius(for size: CGSize) -> CGFloat {
    min(size.width, size.height) / 20
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
