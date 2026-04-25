//
//  BrowserManager.swift
//  DefaultBrowserSwitcher
//
//  Created by ozawako1 on 2026/04/25.
//

import AppKit
import CoreServices
import Observation

struct Browser: Identifiable {
    let id: String
    let name: String
    let icon: NSImage
}

@Observable
@MainActor
class BrowserManager {
    var browsers: [Browser] = []
    var defaultBrowserID: String? = nil

    func load() {
        guard let dummyURL = URL(string: "https://example.com") else { return }
        let appURLs = NSWorkspace.shared.urlsForApplications(toOpen: dummyURL)

        browsers = appURLs.compactMap { url in
            guard let bundle = Bundle(url: url),
                  let bundleID = bundle.bundleIdentifier else { return nil }
            let name = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
                ?? bundle.object(forInfoDictionaryKey: "CFBundleName") as? String
                ?? url.deletingPathExtension().lastPathComponent
            let icon = NSWorkspace.shared.icon(forFile: url.path)
            return Browser(id: bundleID, name: name, icon: icon)
        }.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }

        loadDefaultBrowser()
    }

    func loadDefaultBrowser() {
        guard let url = NSWorkspace.shared.urlForApplication(toOpen: URL(string: "https://example.com")!),
              let bundleID = Bundle(url: url)?.bundleIdentifier else { return }
        defaultBrowserID = bundleID
    }

    func setDefault(_ browser: Browser) {
        LSSetDefaultHandlerForURLScheme("https" as CFString, browser.id as CFString)
        LSSetDefaultHandlerForURLScheme("http" as CFString, browser.id as CFString)
        defaultBrowserID = browser.id
    }
}
