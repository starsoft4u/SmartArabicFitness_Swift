//
//  PlansVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/24.
//  Copyright © 2018 raptor. All rights reserved.
//

import CoreStore
import DropDown
import DZNEmptyDataSet
import UIKit

class PlanCell: UITableViewCell {
    @IBOutlet weak var planImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var onDetailTapped: ((_ button: UIButton) -> Void)?

    @IBAction func onDetailAction(_ sender: UIButton) {
        onDetailTapped?(sender)
    }
}

class PlansVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var plans: [Plans] = []

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let spliteVC = splitViewController else { return }
        hasMenu = spliteVC.displayMode == .allVisible
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        makeMenu()
        setupAds()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        loadPlans()
    }

    fileprivate func loadPlans() {
        let skip: Int64 = isMale ? 2 : 1

        do {
            let query = From<Plans>().where(\.id != skip).orderBy(.ascending(\.id), .descending(\.isDefault))
            plans = try CoreStore.fetchAll(query)
        } catch {
            plans = []
        }

        tableView.reloadData()
    }

    @objc fileprivate func onPlanItemDetailAction(button: UIButton, planIndex: Int) {
        let plan = plans[planIndex]
        let dropDown = DropDown(anchorView: button)
        if plan.isDefault {
            dropDown.dataSource = ["Add Log".localized]
        } else {
            dropDown.dataSource = ["Edit".localized, "Add Log".localized, "Delete".localized]
        }
        dropDown.width = 120
        dropDown.selectionAction = { [unowned self] index, _ in
            if plan.isDefault || index == 1 {
                // Add Log
                let vc = AppStoryboard.Plan.viewController(viewControllerClass: AddLogVC.self)
                vc.plan = plan
                self.navigationController?.pushViewController(vc, animated: true)
            } else if index == 0 {
                // Edit Plan
                let vc = AppStoryboard.Plan.viewController(viewControllerClass: PlanEditVC.self)
                vc.plan = plan
                self.navigationController?.pushViewController(vc, animated: true)
            } else if index == 2 {
                // Delete Plan
                CoreStore.perform(
                    asynchronous: { transaction in
                        try transaction.deleteAll(From<PlanExercices>().where(\.planId == plan.id))
                        try transaction.deleteAll(From<Logs>().where(\.planId == plan.id))
                        transaction.delete(plan)
                    },
                    completion: { _ in
                        self.plans.remove(at: planIndex)
                        self.tableView.reloadData()
                    }
                )
            }
        }
        if !isEn {
            dropDown.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
            dropDown.customCellConfiguration = { _, _, cell in
                cell.optionLabel.textAlignment = .right
                cell.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: 1))
            }
        }
        dropDown.show()
    }

    // MARK: - Navigation

    @IBAction func unwind2Plans(_ segue: UIStoryboardSegue) {
        if segue.source is PlanEditVC {
            loadPlans()
        }
    }
}

extension PlansVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as? PlanCell else {
            fatalError("Unable to deque reusable cellf or identifier PlanCell")
        }

        let plan = plans[indexPath.row]
        cell.nameLabel.text = plan.name?.localized
        cell.onDetailTapped = { [unowned self] button in
            self.onPlanItemDetailAction(button: button, planIndex: indexPath.row)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let plan = plans[indexPath.row]

        switch plan.id {
        case 3:
            performSegue(withIdentifier: "fullBodyTraingingPlan", sender: plan)
        case 4...7:
            let vc = AppStoryboard.Plan.viewController(viewControllerClass: SplitPlanVC.self)
            vc.plan = plan
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = AppStoryboard.Plan.viewController(viewControllerClass: PlanExercicesVC.self)
            vc.plan = plan
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension PlansVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return "No result"
            .localized
            .withTextColor(.darkGray)
            .withFont(UIFont.systemFont(ofSize: 17))
    }
}
