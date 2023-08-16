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

    func saveIncomes(_ incomes: [Income]) {
        do {
            let data = try JSONEncoder().encode(incomes)
            let url = getDocumentsDirectory().appendingPathComponent("incomes.json")
            try data.write(to: url)
        } catch {
            print("Error saving incomes: \(error)")
        }
    }

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

    func saveExpenses(_ expenses: [Expense]) {
        do {
            let data = try JSONEncoder().encode(expenses)
            let url = getDocumentsDirectory().appendingPathComponent("expenses.json")
            try data.write(to: url)
        } catch {
            print("Error saving expenses: \(error)")
        }
    }

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

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
