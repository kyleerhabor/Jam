//
//  JamApp.swift
//  Jam
//
//  Created by Kyle Erhabor on 11/11/23.
//

import SwiftUI

@main
struct JamApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate

  private let width: CGFloat = 256
  private let height: CGFloat = 160

  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(minWidth: width, minHeight: height)
    }
    .windowResizability(.contentMinSize)
    .defaultSize(width: width, height: height)
  }
}
