//
//  AddView.swift
//  iExpense
//
//  Created by HiRO on 18/05/25.
//

import SwiftData
import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount: Double = 0
    
    let types: [String] = ["Personal", "Business"]
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Comment", text: $name)
                
                Picker("Selection", selection: $type) {
                    ForEach(types, id: \.self) { type in
                        Text(type)
                    }
                }
                
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
            }
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
                    guard !name.isEmpty, amount > 0 else { return }
                    let item = Expense(name: name, type: type, amount: amount)
                    modelContext.insert(item)
                    dismiss()
                }
                .disabled(name.isEmpty && amount < 0)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddView()
}
