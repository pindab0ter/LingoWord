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
                    .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2666666667, green: 0.5882352941, blue: 0.8352941176, alpha: 1)), Color(#colorLiteral(red: 0.06666666667, green: 0.4117647059, blue: 0.7647058824, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                    .shadow(radius: radius(for: geometry.size))
                
                if letter.status == .unplaced {
                    Circle()
                        .fill(Color(#colorLiteral(red: 0.862745098, green: 0.7254901961, blue: 0.3137254902, alpha: 1)))
                } else if letter.status == .placed {
                    RoundedRectangle(cornerRadius: radius(for: geometry.size))
                        .fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9176470588, green: 0.2235294118, blue: 0.2784313725, alpha: 1)), Color(#colorLiteral(red: 0.9058823529, green: 0.1215686275, blue: 0.1882352941, alpha: 1)), Color(#colorLiteral(red: 0.9058823529, green: 0.1215686275, blue: 0.1882352941, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                }
                Text(String(letter.character?.uppercased() ?? "."))
                    .shadow(radius: radius(for: geometry.size))
            }
            .foregroundColor(.white)
            .font(Font.system(size: fontSize(for: geometry.size), weight: .bold, design: .default))
        }
    }
}
