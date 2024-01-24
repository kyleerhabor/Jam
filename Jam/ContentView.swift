//
//  ContentView.swift
//  Jam
//
//  Created by Kyle Erhabor on 11/11/23.
//

import KeyboardShortcuts
import PrivateMediaRemote
import SwiftUI

extension UserDefaults {
  static let seekKey = "seek"
}

struct ContentView: View {
  @AppStorage(UserDefaults.seekKey) private var seek = 15
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

      Stepper("Seek by:", value: seek, in: seekLimit, step: 1, format: .number)
    }
  }
}

#Preview {
  ContentView()
}
