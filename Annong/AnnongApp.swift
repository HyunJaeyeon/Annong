//
//  AnnongApp.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/13/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore
import AuthenticationServices

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AnnongApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .preferredColorScheme(.dark)
        }
    }
}
