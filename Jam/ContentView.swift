//
//  ContentView.swift
//  Jam
//
//  Created by Kyle Erhabor on 11/11/23.
//

import KeyboardShortcuts
import SwiftUI

struct StorageKey<Value> {
  let name: String
  let defaultValue: Value
}

extension StorageKey {
  init(_ name: String, defaultValue: Value) {
    self.init(name: name, defaultValue: defaultValue)
  }
}

extension StorageKey: Sendable where Value: Sendable {}

extension AppStorage {
  init(_ key: StorageKey<Value>) where Value == Int {
    self.init(wrappedValue: key.defaultValue, key.name)
  }

  init(_ key: StorageKey<Value>) where Value: RawRepresentable,
                                       Value.RawValue == Int {
    self.init(wrappedValue: key.defaultValue, key.name)
  }
}


enum Application: Int {
  case none, doppler
}

enum StorageKeys {
  static let seekRate = StorageKey("seek-rate", defaultValue: 15)
  static let application = StorageKey("application", defaultValue: Application.none)
}

struct ContentView: View {
  @AppStorage(StorageKeys.seekRate) private var seekRate
  @AppStorage(StorageKeys.application) private var application
  private let seek = 1...Double(Int.max)

  var body: some View {
    Form {
      KeyboardShortcuts.Recorder("Back:", name: .back)
      KeyboardShortcuts.Recorder("Forward:", name: .forward)

      let seekRate = Binding {
        Double(self.seekRate)
      } set: { seekRate in
        self.seekRate = Int(seek.clamp(seekRate))
      }

      Stepper("Content.SeekRate", value: seekRate, in: seek, step: 1, format: .number)

      Picker("Content.Application", selection: $application) {
        Section {
          Text("Content.Application.None")
            .tag(Application.none)
        }

        Section {
          Text("Content.Application.Doppler")
            .tag(Application.doppler)
        }
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
