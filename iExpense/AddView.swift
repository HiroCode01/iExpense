//
//  AddView.swift
//  iExpense
//
//  Created by HiRO on 18/05/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount: Double = 0
    
    var expenses: Expenses
    let types: [String] = ["Personal", "Business"]
    
    var body: some View {
        Form {
            TextField("Comment", text: $name)
            
            Picker("Selection", selection: $type) {
                ForEach(types, id: \.self) { type in
                    Text(type)
                }
            }
            
            TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .keyboardType(.decimalPad)
        }
        .navigationTitle(Text("Add New Expense"))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    guard !name.isEmpty else { return }
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddView(expenses: Expenses())
}
