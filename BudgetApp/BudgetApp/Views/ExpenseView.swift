//
//  ExpenseView.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class ExpenseView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var expenseLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var expenseTableView: UITableView!
    @IBOutlet weak var addExpenseButton: UIButton!
    
    let viewModel = ExpenseViewModel()
    
    var expenseAddedHandler: ((Expense) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseTableView.delegate = self
        expenseTableView.dataSource = self
        updateUi()
    }
    
    func updateUi() {
        let sum = viewModel.addUp()
        totalExpenseLabel.text = "Total Expense:\(sum)"
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addExpenseVC = storyboard.instantiateViewController(withIdentifier: "AddExpenseViewController") as? AddExpenseViewController {
            
            addExpenseVC.expenseAddedHandler = { [weak self] newItem in
                self?.viewModel.expenses.append(newItem)
                self?.expenseTableView.reloadData()
                self?.updateUi()
            }
            present(addExpenseVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfExpenses()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        let expense = viewModel.expense(at: indexPath.row)
        
        cell.textLabel?.text = expense.name
        cell.detailTextLabel?.text = String(format: "$%.2f", expense.cost!)
        
        return cell
    }
}
