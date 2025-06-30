//
// iExpense
// Expense.swift
//
// Created by HiRO on 30/06/25
// Copyright © 2025 ACME. All Rights Reserved.

import SwiftData
import Foundation

@Model
class Expense {
    var name: String
    var type: String
    var amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}
