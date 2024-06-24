//
//  AnnongApp.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/13/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

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
    
    var modelContainer: ModelContainer = {
        let schema = Schema([User.self, Post.self])
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema,
                                      configurations: [modelConfiguration])
        } catch {
            fatalError("modelContainer가 생성되지 않았습니다: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .modelContainer(modelContainer)
                .preferredColorScheme(.dark)
        }
    }
    init(){
           print(URL.applicationSupportDirectory.path(percentEncoded: false))
       }
}
