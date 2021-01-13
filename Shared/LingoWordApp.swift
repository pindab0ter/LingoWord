//
//  LingoWordApp.swift
//  Shared
//
//  Created by Hans van Luttikhuizen-Ross on 09/01/2021.
//

import SwiftUI

@main
struct LingoWordApp: App {
    private let controller = LingoWordController()

    var body: some Scene {
        WindowGroup {
            LingoWordView(controller: controller)
        }
    }
}
