//
//  ContentView.swift
//  DefaultBrowserSwitcher
//
//  Created by ozawako1 on 2026/04/25.
//

import SwiftUI

struct ContentView: View {
    var manager: BrowserManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if manager.browsers.isEmpty {
                Text("ブラウザが見つかりません")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 5)
            } else {
                ForEach(manager.browsers) { browser in
                    Button(action: {
                        manager.setDefault(browser)
                    }) {
                        if browser.id == manager.defaultBrowserID {
                            Label(browser.name, systemImage: "checkmark")
                        } else {
                            Text(browser.name)
                        }
                    }
                }
            }

            Divider()

            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack {
                    Text("Quit")
                    Spacer()
                    Text("⌘Q")
                        .foregroundStyle(.secondary)
                        .font(.system(size: 11))
                }
            }
        }
    }
}

#Preview {
    ContentView(manager: BrowserManager())
}
