//
//  AppDelegate.swift
//  Jam
//
//  Created by Kyle Erhabor on 11/11/23.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    let app = notification.object as! NSApplication
    
    // We don't want to show any windows on launch (there is probably a better way to do this).
    app.windows.forEach { $0.close() }
  }
}
