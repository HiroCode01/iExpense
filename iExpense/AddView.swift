//
//  AddView.swift
//  iExpense
//
//  Created by HiRO on 18/05/25.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses: Expenses
    let types: [String] = ["Personal", "Business"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Comment", text: $name)
                
                Picker("Selection", selection: $type) {
                    ForEach(types, id: \.self) { type in
                        Text(type)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle(Text("Add New Expense"))
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
