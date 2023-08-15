//
//  BudgetView.swift
//  BudgetApp
//
//  Created by Gökhan Gökoğlan on 12.08.2023.
//

import UIKit

class BudgetView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var budgetShownLabel: UILabel!
    @IBOutlet weak var assetsTableView: UITableView!
    
    let budgetModel = BudgetViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        budgetModel.addToAssets()
        updateUi()
    }
    
    func setupTableView() {
        assetsTableView.delegate = self
        assetsTableView.dataSource = self
    }
    
    func updateUi() {
        let currentMonth = budgetModel.getCurrentMonth()
        budgetLabel.text = "\(currentMonth)"
        budgetShownLabel.text = budgetModel.mainBudgetString
        budgetModel.recalculateAssets()
        budgetModel.updateMonthlyData()
    }
    
    @IBAction func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            animateRefreshUI()
        }
    }
    
    func updateUiAndReloadTableView() {
        DispatchQueue.main.async {
            self.updateUi()
            self.assetsTableView.reloadData()
        }
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return budgetModel.numberOfAssets()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assetCell", for: indexPath)
            let assets = budgetModel.asset(at: indexPath.row)

            let currentMonth = budgetModel.getCurrentMonth()
            let monthlyTotalIncome = budgetModel.getMonthlyTotalIncome(for: currentMonth)
            let monthlyTotalExpense = budgetModel.getMonthlyTotalExpense(for: currentMonth)
            let monthlyDifference = budgetModel.getMonthlyDifference(for: currentMonth)

            if indexPath.row == 0 {
                cell.textLabel?.text = "Total Income"
                cell.detailTextLabel?.text = String(format: "$%.2f", monthlyTotalIncome)
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Total Expense"
                cell.detailTextLabel?.text = String(format: "$%.2f", monthlyTotalExpense)
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Difference"
                cell.detailTextLabel?.text = String(format: "$%.2f", monthlyDifference)
            } else {
                cell.textLabel?.text = assets.name
                cell.detailTextLabel?.text = String(format: "$%.2f", assets.cost!)
            }
        return cell
    }
    
    func animateRefreshUI() {
        UIView.animate(withDuration: 0.3, animations: {
            self.budgetShownLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.budgetShownLabel.alpha = 0.5
            self.assetsTableView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.assetsTableView.alpha = 0.5
        }, completion: { _ in
            self.updateUiAndReloadTableView()
            self.resetUIAnimation()
        })
    }

    func resetUIAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.budgetShownLabel.transform = .identity
            self.budgetShownLabel.alpha = 1.0
            self.assetsTableView.transform = .identity
            self.assetsTableView.alpha = 1.0
        })
    }
}
