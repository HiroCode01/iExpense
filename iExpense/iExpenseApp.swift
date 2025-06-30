//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Fazliddin Abdazimov on 16/05/25.
//

import SwiftData
import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
