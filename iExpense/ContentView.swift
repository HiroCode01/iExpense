//
//  ContentView.swift
//  iExpense
//
//  Created by HiRO on 16/05/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    @State private var showingAddExpance: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter{$0.type == "Personal"}) { item in
                        ExpencesItemView(item: item)
                    }
                    .onDelete{ offsets in removeItems(typeOf: "Personal", at: offsets) }
                }
                
                Section("Business") {
                    ForEach(expenses.items.filter{$0.type == "Business"}) { item in
                        ExpencesItemView(item: item)
                    }
                    .onDelete{ offsets in removeItems(typeOf: "Business", at: offsets) }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpance = true
                }
            }
            .sheet(isPresented: $showingAddExpance) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(typeOf type: String, at offsets: IndexSet) {
        let allOfType = expenses.items.enumerated()
            .filter { $0.element.type == type }
        
        let indicesToDelete = offsets.map { allOfType[$0].offset }
        expenses.items.remove(atOffsets: IndexSet(indicesToDelete))
    }
}

#Preview {
    ContentView()
}

struct ExpencesItemView: View {
    var item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.title2.bold())
                
                Text(item.type)
                    .foregroundStyle(Color("TextAccentColor"))
            }
            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(Color(item.amount >= 100 ? "HighNumberCurrency" : item.amount >= 10 ? "MiddleNumberCurrency" : "SmallNumberCurrency"))
        }
    }
}
