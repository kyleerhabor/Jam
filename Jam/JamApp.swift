//
//  JamApp.swift
//  Jam
//
//  Created by Kyle Erhabor on 11/11/23.
//

import KeyboardShortcuts
import OSLog
import SwiftUI

@main
struct JamApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) private var delegate

  private let width: CGFloat = 256
  private let height: CGFloat = 160
  private static let dopplerPlayerPosition = NSAppleScript(source: "tell application \"Doppler\" to return player position")

  var body: some Scene {
    WindowGroup {
      ContentView()
        .frame(minWidth: width, minHeight: height)
    }
    .windowResizability(.contentMinSize)
    .defaultSize(width: width, height: height)
  }

  init() {
    let stream = AsyncStream(KeyboardShortcuts.Name.self, bufferingPolicy: .bufferingNewest(8)) { continuation in
      KeyboardShortcuts.onKeyDown(for: .back) {
        continuation.yield(.back)
      }

      KeyboardShortcuts.onKeyDown(for: .forward) {
        continuation.yield(.forward)
      }
    }

    Task {
      let positions = stream.compactMap { action -> Double? in
        guard UserDefaults.standard.integer(forKey: StorageKeys.application.name) == Application.doppler.rawValue,
              let position = await Self.position() else {
          return nil
        }

        let seekRate = UserDefaults.standard.double(forKey: StorageKeys.seekRate.name)

        switch action {
          case .back: return position - seekRate
          case .forward: return position + seekRate
          default: return nil
        }
      }

      for await position in positions {
        await Self.setPosition(to: position)
      }
    }
  }

  static func position() async -> Double? {
    guard let appleScript = dopplerPlayerPosition else {
      return nil
    }

    var errorInfo: NSDictionary?
    let descriptor = appleScript.executeAndReturnError(&errorInfo)

    if let errorInfo {
      Logger.standard.error("\(errorInfo)")

      return nil
    }

    return descriptor.doubleValue
  }

  static func setPosition(to position: Double) async {
    guard let appleScript = NSAppleScript(source: "tell application \"Doppler\" to set player position to \(position)") else {
      return
    }

    var errorInfo: NSDictionary?
    appleScript.executeAndReturnError(&errorInfo)

    if let errorInfo {
      Logger.standard.error("\(errorInfo)")
    }
  }
}
