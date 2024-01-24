//
//  Standard.swift
//  Jam
//
//  Created by Kyle Erhabor on 1/23/24.
//

import Foundation
import KeyboardShortcuts
import OSLog

extension Bundle {
  static let identifier = Bundle.main.bundleIdentifier!
}

extension Logger {
  static let standard = Self()
}

extension DispatchQueue {
  static let mediaremote = DispatchQueue(label: "\(Bundle.identifier).MediaRemote", qos: .userInitiated)
}

extension ClosedRange {
  func clamp(_ value: Bound) -> Bound {
    Swift.max(self.lowerBound, Swift.min(value, self.upperBound))
  }
}

// MARK: - Keyboard shortcuts

extension KeyboardShortcuts.Name {
  static let forward = Self("forward")
  static let back = Self("back")
}
