//
//  ContentView.swift
//  Jam
//
//  Created by Kyle Erhabor on 11/11/23.
//

import KeyboardShortcuts
import OSLog
import PrivateMediaRemote
import SwiftUI

extension Bundle {
  static let identifier = Bundle.main.bundleIdentifier!
}

extension KeyboardShortcuts.Name {
  static let forward = Self("forward")
  static let back = Self("back")
}

extension ClosedRange {
  func clamp(_ value: Bound) -> Bound {
    Swift.max(self.lowerBound, Swift.min(value, self.upperBound))
  }
}

struct ContentView: View {
  @AppStorage("seek") private var seek = 15
  private let seekLimit = 1...Double(Int.max)

  var body: some View {
    Form {
      KeyboardShortcuts.Recorder("Forward:", name: .forward)
      KeyboardShortcuts.Recorder("Back:", name: .back)

      let seek = Binding {
        Double(self.seek)
      } set: { seek in
        self.seek = Int(seekLimit.clamp(seek))
      }

      Stepper("Seek by:", value: seek, in: 1...Double(Int.max), step: 1, format: .number)
    }.onAppear {
      KeyboardShortcuts.onKeyDown(for: .forward) {
        Task {
          MRMediaRemoteSetElapsedTime(try await elapsed() + Double(seek))
        }
      }

      KeyboardShortcuts.onKeyDown(for: .back) {
        Task {
          MRMediaRemoteSetElapsedTime(try await elapsed() - Double(seek))
        }
      }
    }
  }

  func elapsed() async throws -> Double {
    try await withCheckedThrowingContinuation { continuation in
      MRMediaRemoteRequestNowPlayingPlaybackQueueForPlayerSync(nil, nil, .global()) { queue, err in
        if let err {
          continuation.resume(throwing: err)

          return
        }

        let queue = queue as! MRPlaybackQueue

        guard let metadata = queue.contentItems.first?.metadata else {
          return
        }

        let elapsed = metadata.calculatedPlaybackPosition

        continuation.resume(returning: elapsed)
      }
    }
  }
}

#Preview {
  ContentView()
}
