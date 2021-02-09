//
//  HapticFinder.swift
//  HapticFinder
//
//  Created by Hlib Hraif on 20/01/2021.
//

import SwiftUI

@main
struct HapticFinder: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
