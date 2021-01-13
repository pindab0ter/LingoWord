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
        ZStack {
            LingoTextField()
                .assign(delegate: controller)
                .opacity(0)
            
            VStack {
                HStack {
                    ForEach(controller.word) { letter in
                        LetterView(letter: letter)
                            .aspectRatio(1, contentMode: .fit)
                            .onTapGesture { controller.toggleLetter(letter: letter) }
                    }
                    if controller.word.count == 0 {
                        GeometryReader { geometry in
                            LetterView(letter: Letter(id: 0, status: .unknown))
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .animation(.easeOut)
                .padding()
                List {
                    if LingoWordSolver.wordLengths.contains(controller.word.count) {
                        if controller.answers.count > 0 {
                            ForEach(controller.answers) { answer in
                                Text(answer.uppercased())
                            }
                        } else {
                            Text("Geen woorden gevonden.")
                        }
                    } else {
                        Text("\(controller.word.count) letter\(controller.word.count != 1 ? "s" : "")")
                    }
                }
            }
            .padding()
        }
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
