//
//  LetterView.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 13/01/2021.
//

import SwiftUI

struct LetterView: View {
    var letter: Letter
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: radius(for: geometry.size))
                    .fill(Color.blue)
                    .shadow(radius: radius(for: geometry.size))
                
                if letter.status == .unplaced {
                    Circle()
                        .fill(Color.yellow)
                } else if letter.status == .placed {
                    RoundedRectangle(cornerRadius: radius(for: geometry.size))
                        .fill(Color.red)
                }

                Text(String(letter.character?.uppercased() ?? "."))
                    .shadow(radius: radius(for: geometry.size))
            }
            .foregroundColor(.white)
            .font(Font.system(size: fontSize(for: geometry.size), weight: .bold, design: .default))
        }
    }
}
