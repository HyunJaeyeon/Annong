//
//  AnnongApp.swift
//  Annong
//
//  Created by Hyun Jaeyeon on 6/13/24.
//

import SwiftUI
import SwiftData

@main
struct AnnongApp: App {
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
            ContentView()
                .modelContainer(modelContainer)
                .preferredColorScheme(.dark)
        }
    }
}
