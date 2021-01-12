//
//  LingoWordView.swift
//  LingoWord
//
//  Created by Hans van Luttikhuizen-Ross on 09/01/2021.
//

import SwiftUI

// TODO: Drag'n'drop to place

struct LingoWordView: View {
    @ObservedObject
    var controller: LingoWordController
    
    var body: some View {
        VStack {
            HStack {
                ForEach(controller.word) { letter in
                    LetterView(letter: letter)
                        .aspectRatio(1, contentMode: .fit)
                }
                if controller.showInput {
                    GeometryReader { geometry in
                        ZStack {
                            LetterView(letter: .incorrect(0, "."))
                            LingoTextField()
                                .assign(delegate: controller)
                                .opacity(0)
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding()
            Spacer()
            VStack {
                ForEach(controller.answers) { answer in
                    Text(answer)
                }
            }
        }
        .padding()
    }
}

// MARK: LetterView

struct LetterView: View {
    var letter: Letter
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: radius(for: geometry.size))
                    .fill(Color.blue)
                    .shadow(radius: radius(for: geometry.size))
                switch letter {
                case .unknown:
                    Text(".")
                        .shadow(radius: radius(for: geometry.size))
                case .unplaced(_, let character):
                    Circle()
                        .fill(Color.yellow)
                    Text(String(character).uppercased())
                        .shadow(radius: radius(for: geometry.size))
                case .placed(_, let character, _):
                    RoundedRectangle(cornerRadius: radius(for: geometry.size))
                        .fill(Color.red)
                    Text(String(character).uppercased())
                        .shadow(radius: radius(for: geometry.size))
                case .incorrect(_, let character):
                    Text(String(character).uppercased())
                        .shadow(radius: radius(for: geometry.size))
                }
            }
            .foregroundColor(.white)
            .font(Font.system(size: fontSize(for: geometry.size), weight: .bold, design: .default))
        }
    }
}

func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * 4/5
}

func radius(for size: CGSize) -> CGFloat {
    min(size.width, size.height) / 20
}

// MARK: Preview

struct LingoWordView_Previews: PreviewProvider {
    static var previews: some View {
        LingoWordView(controller: LingoWordController())
    }
}
