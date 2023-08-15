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
        changeMonth()
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
    
    func changeMonth() {
        let currentMonth = viewModel.getCurrentMonth()
        expenseLabel.text = "\(currentMonth)"
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groupedExpenses.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = Array(viewModel.groupedExpenses.keys)[section]
        return viewModel.groupedExpenses[sectionKey]?.count ?? 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionKey = Array(viewModel.groupedExpenses.keys)[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        if let expensesForMonth = viewModel.groupedExpenses[sectionKey] {
            let expense = expensesForMonth[indexPath.row]
            
            cell.textLabel?.text = expense.name
            cell.detailTextLabel?.text = String(format: "$%.2f", expense.cost!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKey = Array(viewModel.groupedExpenses.keys)[section]
        return sectionKey // Display the formatted month and year as the section header
    }
}
