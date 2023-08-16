//
//  DataManager.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 16.08.2023.
//
import Foundation

class DataManager {
    static let shared = DataManager()
    private init() {}

    // Save incomes to a file
    func saveIncomes(_ incomes: [Income]) {
        do {
            let data = try JSONEncoder().encode(incomes)
            let url = getDocumentsDirectory().appendingPathComponent("incomes.json")
            try data.write(to: url)
        } catch {
            print("Error saving incomes: \(error)")
        }
    }

    // Load incomes from file
    func loadIncomes() -> [Income] {
        let url = getDocumentsDirectory().appendingPathComponent("incomes.json")
        do {
            let data = try Data(contentsOf: url)
            let incomes = try JSONDecoder().decode([Income].self, from: data)
            return incomes
        } catch {
            print("Error loading incomes: \(error)")
            return []
        }
    }

    // Save expenses to a file
    func saveExpenses(_ expenses: [Expense]) {
        do {
            let data = try JSONEncoder().encode(expenses)
            let url = getDocumentsDirectory().appendingPathComponent("expenses.json")
            try data.write(to: url)
        } catch {
            print("Error saving expenses: \(error)")
        }
    }

    // Load expenses from file
    func loadExpenses() -> [Expense] {
        let url = getDocumentsDirectory().appendingPathComponent("expenses.json")
        do {
            let data = try Data(contentsOf: url)
            let expenses = try JSONDecoder().decode([Expense].self, from: data)
            return expenses
        } catch {
            print("Error loading expenses: \(error)")
            return []
        }
    }

    // Get the documents directory
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
