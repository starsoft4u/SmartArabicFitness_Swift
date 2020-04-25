//
//  ExercicesVC.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/20.
//  Copyright © 2018 raptor. All rights reserved.
//

import CoreStore
import DropDown
import DZNEmptyDataSet
import SwiftyAttributes
import UIKit

class ExercicesVC: UIViewController {
    @IBOutlet weak var muscleButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var planId: Int64 = 0
    var muscleId: Int = 0
    var muscles: [Muscles] = []
    var exercices: [Exercices] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAds()

        // TableView
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView(frame: CGRect.zero)

        // Load cell
        loadMuscles()
        loadExercices(muscleId: muscleId)
    }

    fileprivate func loadMuscles() {
        do {
            muscles = try CoreStore.fetchAll(From<Muscles>().orderBy(.ascending(\.id)))

            if muscleId == 0 {
                navigationItem.title = "All Exercices".localized
                muscleButton.setTitle("All Exercices".localized, for: .normal)
            } else {
                let current = muscles.first { $0.id == muscleId }
                let name = isEn ? current?.enName : current?.arName
                navigationItem.title = name
                muscleButton.setTitle(name, for: .normal)
            }
        } catch {
            muscles = []
            navigationItem.title = nil
            muscleButton.setTitle(nil, for: .normal)
        }
    }

    fileprivate func loadExercices(muscleId: Int) {
        self.muscleId = muscleId

        do {
            let gender = isMale ? "female" : "male"
            if self.muscleId > 0 {
                let query = From<Exercices>()
                    .where(\.muscleId == Int64(self.muscleId) && \.gender != gender && \.isPremium == false)
                    .orderBy(.ascending(\.id))
                exercices = try CoreStore.fetchAll(query)
            } else {
                let query = From<Exercices>()
                    .where(\.gender != gender && \.isPremium == false)
                    .orderBy(.ascending(\.id))
                exercices = try CoreStore.fetchAll(query)
            }
        } catch {
            exercices = []
        }

        tableView.reloadData()
    }

    @IBAction func onMuscleSelectAction(_ sender: UIButton) {
        let dropDown = DropDown(anchorView: sender)
        dropDown.dataSource = ["All Exercices".localized] + muscles.map { isEn ? $0.enName! : $0.arName! }
        if muscleId == 0 {
            dropDown.selectRow(0)
        } else if let item = muscles.first(where: { $0.id == self.muscleId }), let index = muscles.firstIndex(of: item) {
            dropDown.selectRow(at: index.advanced(by: 1))
        }
        dropDown.customCellConfiguration = { _, _, cell in
            cell.optionLabel.textAlignment = self.isEn ? .left : .right
        }
        dropDown.selectionAction = { [unowned self] index, item in
            sender.setTitle(item, for: .normal)
            if index == 0 {
                self.loadExercices(muscleId: 0)
            } else {
                self.loadExercices(muscleId: Int(self.muscles[index - 1].id))
            }
            self.navigationItem.title = item
        }
        dropDown.show()
    }
}

extension ExercicesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)

        let exercise = exercices[indexPath.row]

        if let imageView = cell.viewWithTag(1) as? UIImageView {
            if let gif = UIImage.gif(name: "\(isMale ? "male" : "female")\(exercise.id)"), let first = gif.images?.first {
                imageView.image = first
            } else {
                imageView.image = UIImage(named: "ic_exercise")
            }
        }
        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = isEn ? exercise.enName : exercise.arName
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let exercise = exercices[indexPath.row]
        let vc = AppStoryboard.Exercices.viewController(viewControllerClass: ExerciseDetailVC.self)
        vc.exercise = exercise
        vc.planId = planId
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExercicesVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return "No result"
            .localized
            .withTextColor(.darkGray)
            .withFont(UIFont.systemFont(ofSize: 17))
    }
}
