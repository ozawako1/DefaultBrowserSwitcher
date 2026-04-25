//
//  DefaultBrowserSwitcherApp.swift
//  DefaultBrowserSwitcher
//
//  Created by ozawako1 on 2026/04/25.
//

import SwiftUI

@main
struct DefaultBrowserSwitcherApp: App {
    @State private var manager = BrowserManager()

    var body: some Scene {
        MenuBarExtra("Default Browser Switcher", systemImage: "globe") {
            ContentView(manager: manager)
        }
        .menuBarExtraStyle(.menu)
    }

    init() {
        let m = BrowserManager()
        m.load()
        _manager = State(initialValue: m)
    }
}
