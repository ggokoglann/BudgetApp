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
    
    private var viewModel = ExpenseViewModel.shared
    
    var expenseAddedHandler: ((Expense) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    func setupTableView() {
        expenseTableView.dataSource = self
        expenseTableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            self?.updateUi()
            self?.expenseTableView.reloadData()
        }
    }
    
    private func updateUi() {
        totalExpenseLabel.text = "Total Expense: \(viewModel.totalExpenseString)"
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addExpenseVC = storyboard.instantiateViewController(withIdentifier: "AddExpenseView") as? AddExpenseView {
            
            addExpenseVC.mainViewModel = viewModel
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
