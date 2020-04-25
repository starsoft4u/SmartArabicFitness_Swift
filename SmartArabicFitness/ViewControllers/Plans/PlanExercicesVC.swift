//
//  PlanExercicesVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/25.
//  Copyright © 2018 raptor. All rights reserved.
//

import Cartography
import CoreStore
import DropDown
import DZNEmptyDataSet
import UIKit
import SwiftyAttributes

class PlanExerciseHeaderCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var extraView1: UILabel!
    @IBOutlet weak var extraView2: UIView!

    func setup(_ views: [UIView]) {
        guard let parent = stackView.superview else {
            return
        }

        // remove bg
        parent.subviews
            .filter { $0 != stackView && $0 != separator }
            .forEach { $0.removeFromSuperview() }

        // remove subviews
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // add subview and bg
        views.forEach {
            stackView.addArrangedSubview($0)

            let view = UIView()
            view.backgroundColor = parent.backgroundColor
            parent.addSubview(view)
            constrain(view, $0) { v1, v2 in
                v1.top == v1.superview!.top
                v1.bottom == v1.superview!.bottom
                v1.leading == v2.leading
                v1.trailing == v2.trailing
            }
        }

        // order
        parent.sendSubviewToBack(separator)
        parent.bringSubviewToFront(stackView)
    }
}

class PlanExerciseCell: UITableViewCell {
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

class PlanExerciseCustomCell: PlanExerciseCell {
    @IBOutlet weak var setsRepsLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!

    var onDetailTapped: ((_ button: UIButton) -> Void)?

    @IBAction func onDetailAction(_ sender: UIButton) {
        onDetailTapped?(sender)
    }
}

class PlanExercicesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewOnly = false
    var plan: Plans!
    var exercices: [(planExercise: PlanExercices, exercise: Exercices)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = plan.name?.localized
        
        setupAds()
        
        if plan.isDefault || viewOnly {
            navigationItem.rightBarButtonItem = nil
        }

        tableView.tableFooterView = UIView(frame: CGRect.zero)

        loadExercices()
    }

    fileprivate func loadExercices() {
        exercices.removeAll()

        do {
            let data = try CoreStore.fetchAll(From<PlanExercices>().where(\.planId == plan.id).orderBy(.ascending(\.id)))
            data.forEach { planExercise in
                do {
                    let exercise = try CoreStore.fetchOne(From<Exercices>().where(\.id == planExercise.exerciseId))
                    if let exercise = exercise {
                        self.exercices.append((planExercise: planExercise, exercise: exercise))
                    }
                } catch {
                    print(error)
                }
            }
        } catch {
            print(error)
        }

        tableView.reloadData()
    }

    @objc fileprivate func onExerciseItemDetailAction(sender: UIButton, exerciseIndex: Int) {
        let dropDown = DropDown(anchorView: sender)
        dropDown.dataSource = ["Edit".localized, "Delete".localized]
        dropDown.width = 120
        dropDown.selectionAction = { [unowned self] index, _ in
            if index == 0 {
                let vc = AppStoryboard.Exercices.viewController(viewControllerClass: ExerciseDetailVC.self)
                vc.planId = self.plan.id
                vc.planExercise = self.exercices[exerciseIndex].planExercise
                vc.exercise = self.exercices[exerciseIndex].exercise
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CoreStore.perform(
                    asynchronous: { transaction in
                        transaction.delete(self.exercices[exerciseIndex].planExercise)
                    },
                    completion: { _ in
                        self.exercices.remove(at: exerciseIndex)
                        self.tableView.reloadData()
                    }
                )
            }
        }
        dropDown.show()
    }

    @IBAction func onAddExerciseActino(_ sender: Any) {
        let vc = AppStoryboard.Exercices.viewController(viewControllerClass: MusclesVC.self)
        vc.planId = plan.id
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func unwind2PlanExercices(_ segue: UIStoryboardSegue) {
        if segue.source is ExerciseDetailVC {
            loadExercices()
        }
    }

    fileprivate func metaItem(title: String?, value: String?) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 10)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = .darkGray
        valueLabel.font = UIFont.systemFont(ofSize: 13)

        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }
}

extension PlanExercicesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercices.isEmpty ? 0 : exercices.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return handleHeaderCell(tableView, cellForRowAt: indexPath)
        } else if plan.isDefault {
            return handleStaticCell(tableView, cellForRowAt: indexPath)
        } else {
            return handleCell(tableView, cellForRowAt: indexPath)
        }
    }

    fileprivate func handleHeaderCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanExerciseHeaderCell.identifier, for: indexPath) as? PlanExerciseHeaderCell else {
            fatalError()
        }

        var child: [UIView] = []
        if plan.isDefault {
            if plan.id == 1 {
                child.append(metaItem(title: "Weeks".localized, value: "5 to 7".localized))
                child.append(metaItem(title: "Times per week".localized, value: "2-3"))
                child.append(metaItem(title: "Exercises".localized, value: "*\(exercices.count)"))
                child.append(metaItem(title: "Rest".localized, value: "60s"))
            } else {
                child.append(metaItem(title: "Weeks".localized, value: "6 to 8".localized))
                child.append(metaItem(title: "Times per week".localized, value: "2"))
                child.append(metaItem(title: "Sets".localized, value: "3"))
                child.append(metaItem(title: "Reps".localized, value: "15"))
                child.append(metaItem(title: "Rest".localized, value: "60s"))
            }
        } else {
            let sets = exercices.map { $0.planExercise.sets }.reduce(0, +)
            let reps = exercices.map { $0.planExercise.reps }.reduce(0, +)
            let rest = exercices.map { $0.planExercise.rest }.reduce(0, +)

            child.append(metaItem(title: "Exercises".localized, value: "*\(exercices.count)"))
            child.append(metaItem(title: "Sets".localized, value: sets.description))
            child.append(metaItem(title: "Reps".localized, value: reps.description))
            child.append(metaItem(title: "Rest".localized, value: "\(rest)s"))
        }

        cell.setup(child)
        cell.extraView1.isHidden = !plan.isDefault
        cell.extraView2.isHidden = !plan.isDefault
        cell.extraView1.attributedText = "\("Cardio".localized) ".withFont(UIFont.systemFont(ofSize: 15)) +
            "INDOOR CYCLING, RUNNING".localized.withTextColor(.orange).withFont(UIFont.systemFont(ofSize: 15))

        return cell
    }

    fileprivate func handleStaticCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanExerciseCell.identifier, for: indexPath) as? PlanExerciseCell else {
            fatalError()
        }

        let exercise = exercices[indexPath.row - 1].exercise

        if let gif = UIImage.gif(name: "\(isMale ? "male" : "female")\(exercise.id)"), let first = gif.images?.first {
            cell.exerciseImage.image = first
        } else {
            cell.exerciseImage.image = UIImage(named: "ic_exercise")
        }
        cell.nameLabel.text = isEn ? exercise.enName : exercise.arName

        return cell
    }

    fileprivate func handleCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanExerciseCustomCell.identifier, for: indexPath) as? PlanExerciseCustomCell else {
            fatalError()
        }

        let item = exercices[indexPath.row - 1]

        if let gif = UIImage.gif(name: "\(isMale ? "male" : "female")\(item.exercise.id)"), let first = gif.images?.first {
            cell.exerciseImage.image = first
        } else {
            cell.exerciseImage.image = UIImage(named: "ic_exercise")
        }
        cell.nameLabel.text = isEn ? item.exercise.enName : item.exercise.arName
        cell.setsRepsLabel.text = "set of reps".localize(values: item.planExercise.sets.description, item.planExercise.reps.description)
        cell.restTimeLabel.text = "Rest between sets".localize(values: item.planExercise.rest.description)
        cell.detailButton.isHidden = viewOnly
        cell.onDetailTapped = { [unowned self] button in
            self.onExerciseItemDetailAction(sender: button, exerciseIndex: indexPath.row - 1)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let exerciseIndex = plan.isDefault ? indexPath.row - 1 : indexPath.row

        let vc = AppStoryboard.Exercices.viewController(viewControllerClass: ExerciseDetailVC.self)
        vc.planId = plan.id
        vc.planExercise = exercices[exerciseIndex].planExercise
        vc.exercise = exercices[exerciseIndex].exercise
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? UITableView.automaticDimension : 100
    }
}

extension PlanExercicesVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return "No result"
            .localized
            .withTextColor(.darkGray)
            .withFont(UIFont.systemFont(ofSize: 17))
    }
}
