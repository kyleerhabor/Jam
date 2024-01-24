//
//  JamApp.swift
//  Jam
//
//  Created by Kyle Erhabor on 11/11/23.
//

import KeyboardShortcuts
import PrivateMediaRemote
import OSLog
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
        let elapsed: Double

        do {
          guard let position = try await Self.elapsed() else {
            return nil
          }

          elapsed = position
        } catch {
          Logger.standard.error("Could not get elapsed time: \(error)")

          return nil
        }

        let seek = UserDefaults.standard.double(forKey: UserDefaults.seekKey)

        switch action {
          case .back: return elapsed - seek
          case .forward: return elapsed + seek
          default: return nil
        }
      }

      for await position in positions {
        MRMediaRemoteSetElapsedTime(position)
      }
    }
  }

  static func elapsed() async throws -> Double? {
    try await withCheckedThrowingContinuation { continuation in
      MRMediaRemoteRequestNowPlayingPlaybackQueueForPlayerSync(nil, nil, .mediaremote) { queue, err in
        if let err {
          continuation.resume(throwing: err)

          return
        }

        let queue = queue as! MRPlaybackQueue

        guard let metadata = queue.contentItems.first?.metadata else {
          continuation.resume(returning: nil)

          return
        }

        let elapsed = metadata.calculatedPlaybackPosition

        continuation.resume(returning: elapsed)
      }
    }
  }
}
