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
        
    private func updateUi() {
        totalIncomeLabel.text = "Total Income: \(viewModel.totalIncomeString)"
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionKey = Array(viewModel.groupedIncomes.keys)[section]
        return sectionKey // Display the formatted month and year as the section header
    }
}
