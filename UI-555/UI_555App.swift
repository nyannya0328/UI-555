//
//  UI_555App.swift
//  UI-555
//
//  Created by nyannyan0328 on 2022/05/04.
//

import SwiftUI

@main
struct UI_555App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
