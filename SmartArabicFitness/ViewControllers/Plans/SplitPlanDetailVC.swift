//
//  SplitPlanDetailVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/30.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit

class SplitPlanDetailVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var navTitle: String?
    var dataSource: [(title: String, detail: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navTitle?.localized

        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

extension SplitPlanDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingCell", for: indexPath)

        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = dataSource[indexPath.row].title.localized
        }
        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = dataSource[indexPath.row].detail.localized
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
