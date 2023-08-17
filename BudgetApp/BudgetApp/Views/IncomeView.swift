//
//  IncomeView.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class IncomeView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var IncomeTableView: UITableView!
    @IBOutlet weak var addIncomeButton: UIButton!
            
    private var viewModel = IncomeViewModel.shared
    
    var incomeAddedHandler: ((Income) -> Void)? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        totalIncome()
        changeMonth()
    }
    
    func setupTableView() {
        IncomeTableView.dataSource = self
        IncomeTableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            self?.updateUi()
            self?.IncomeTableView.reloadData()
        }
    }
    
    func changeMonth() {
        let currentMonth = viewModel.getCurrentMonth()
        incomeLabel.text = "\(currentMonth)"
    }
    
    func totalIncome() {
        let total = viewModel.calculateTotalIncome(from: viewModel.incomes)
        totalIncomeLabel.text = "Total Income: \(total)"
    }
        
    private func updateUi() {
        totalIncomeLabel.text = "Total Income: $\(viewModel.totalIncomeString)"
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addIncomeVC = storyboard.instantiateViewController(withIdentifier: "AddIncomeView") as? AddIncomeView {
            
            addIncomeVC.mainViewModel = viewModel
            present(addIncomeVC, animated: true, completion: nil)
        }
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groupedIncomes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKey = Array(viewModel.groupedIncomes.keys)[section]
        return viewModel.groupedIncomes[sectionKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionKey = Array(viewModel.groupedIncomes.keys)[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell", for: indexPath)
        
        if let incomesForMonth = viewModel.groupedIncomes[sectionKey] {
            let income = incomesForMonth[indexPath.row]
            
            cell.textLabel?.text = income.name
            cell.detailTextLabel?.text = String(format: "$%.2f", income.cost!)
            
            return cell
        }        
        return UITableViewCell() // Return a default cell if incomesForMonth is nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let sectionKey = Array(viewModel.groupedIncomes.keys)[indexPath.section]

            if let incomesForMonth = viewModel.groupedIncomes[sectionKey] {
                let income = incomesForMonth[indexPath.row]

                let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
                    if let self = self {
                        self.deleteIncome(income: income)
                        completionHandler(true)
                    }
                }
                deleteAction.image = UIImage(systemName: "trash")
                let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
                swipeActions.performsFirstActionWithFullSwipe = true
                return swipeActions
            }
        return nil
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKey = Array(viewModel.groupedIncomes.keys)[section]
        return sectionKey
    }
    
    private func deleteIncome(income: Income) {
        if let sectionKey = viewModel.groupedIncomes.first(where: { $0.value.contains(income) })?.key,
           let index = viewModel.groupedIncomes[sectionKey]?.firstIndex(where: { $0 == income }) {
            viewModel.deleteIncome(at: index)
            viewModel.saveIncomes()
        }
    }
}
