//
//  ContentView.swift
//  iExpense
//
//  Created by HiRO on 16/05/25.
//
import SwiftData
import SwiftUI

enum FilterType: String, CaseIterable, Identifiable {
    case all = "All"
    case personal = "Personal"
    case business = "Business"

    var id: String { rawValue }
}

enum SortType: String, CaseIterable {
    case name = "Name"
    case amount = "Amount"
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    
    @State private var selectedSortType: SortType = .name
    @State private var selectedFilter: FilterType = .all
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredAndSortedExpenses) { item in
                    ExpensesItemView(item: item)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let item = filteredAndSortedExpenses[index]
                        modelContext.delete(item)
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Menu("Filter", systemImage: "list.bullet.circle") {
                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(FilterType.allCases) { filter in
                            Text(filter.rawValue).tag(filter)
                        }
                    }
                }

                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $selectedSortType) {
                        ForEach(SortType.allCases, id: \.self) { sort in
                            Text(sort.rawValue).tag(sort)
                        }
                    }
                }

                NavigationLink(value: "addExpense") {
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
    
    var filteredAndSortedExpenses: [Expense] {
        let filtered: [Expense]
        switch selectedFilter {
        case .all:
            filtered = expenses
        case .personal:
            filtered = expenses.filter { $0.type.lowercased() == "personal" }
        case .business:
            filtered = expenses.filter { $0.type.lowercased() == "business" }
        }

        return filtered.sorted {
            switch selectedSortType {
            case .name:
                return $0.name < $1.name
            case .amount:
                return $1.amount < $0.amount
            }
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
                    .foregroundStyle(item.type.lowercased() == "business" ? .red.opacity(0.5) : .mint.opacity(0.5))
            }
            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundStyle(Color(item.amount >= 100 ? "HighNumberCurrency" : item.amount >= 10 ? "MiddleNumberCurrency" : "SmallNumberCurrency"))
        }
    }
}
