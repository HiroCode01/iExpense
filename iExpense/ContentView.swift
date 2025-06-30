//
//  ContentView.swift
//  iExpense
//
//  Created by HiRO on 16/05/25.
//
import SwiftData
import SwiftUI

enum SortType: String, CaseIterable {
    case name = "Name"
    case amount = "Amount"
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.filter{$0.type == "Personal"}) { item in
                        ExpensesItemView(item: item)
                    }
                    .onDelete { deleteItems(ofType: "Personal", at: $0) }
                }
                
                
                Section("Business") {
                    ForEach(expenses.filter{$0.type == "Business"}) { item in
                        ExpensesItemView(item: item)
                    }
                    .onDelete { deleteItems(ofType: "Business", at: $0) }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink(value: "addExpense"){
                    Label("Add Expense", systemImage: "plus")
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "addExpense" {
                    AddView()
                }
            }
        }
    }
    
    
    func deleteItems(ofType type: String, at indexSet: IndexSet) {
        let filteredItems = expenses.filter { $0.type == type }
        for index in indexSet {
            let item = filteredItems[index]
            modelContext.delete(item)
        }
    }
    
}

#Preview {
    ContentView()
}

struct ExpensesItemView: View {
    var item: Expense
    
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
