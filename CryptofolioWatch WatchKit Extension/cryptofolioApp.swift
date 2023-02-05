//
//  cryptofolioApp.swift
//  CryptofolioWatch WatchKit Extension
//
//  Created by Marshall Kurniawan on 17/05/22.
//

import SwiftUI

@main
struct cryptofolioApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
