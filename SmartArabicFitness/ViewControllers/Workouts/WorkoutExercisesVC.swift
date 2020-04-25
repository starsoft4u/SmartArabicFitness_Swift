//
//  WorkoutExercisesVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/9/13.
//  Copyright © 2018 raptor. All rights reserved.
//

import Cartography
import CoreStore
import SwiftGifOrigin
import UIKit

class WorkoutExerciseHeaderCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var separator: UIView!

    func setup(_ views: [UIView]) {
        // remove bg
        contentView.subviews
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
            view.backgroundColor = contentView.backgroundColor
            contentView.addSubview(view)
            constrain(view, $0) { v1, v2 in
                v1.top == v1.superview!.top
                v1.bottom == v1.superview!.bottom
                v1.leading == v2.leading
                v1.trailing == v2.trailing
            }
        }

        // order
        contentView.sendSubviewToBack(separator)
        contentView.bringSubviewToFront(stackView)
    }
}

class WorkoutExerciseCell: UITableViewCell {
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
}

typealias WorkoutMeta = (exercise: Int, repsExercise: Int, repsSet: Int, sets: Int, perRep: Int, betweenSets: Int, betweenExercices: Int)

class WorkoutExercisesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var workout: Workouts!
    var level: Int64 = 1
    var exercises: [Exercices] = []

    var meta: WorkoutMeta!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = level == 1 ? "Beginner".localized : "Advanced".localized
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        loadExercises()
        loadMeta()
    }

    fileprivate func loadExercises() {
        exercises = []
        var ids: [Int64] = []
        do {
            let query = From<WorkoutExercises>().where(\.workoutId == workout.id && \.level == level).orderBy(.ascending(\.id))
            ids = try CoreStore.fetchAll(query).map { $0.exerciseId }
        } catch {
            return
        }

        ids.forEach { exerciseId in
            do {
                let exercise = try CoreStore.fetchOne(From<Exercices>().where(\.id == exerciseId))
                if let exercise = exercise {
                    self.exercises.append(exercise)
                }
            } catch {
                print(error)
            }
        }
    }

    fileprivate func loadMeta() {
        if let levelData = level == 1 ? workout.level1 : workout.level2 {
            let ary = levelData.split(separator: ",").map(String.init)

            meta = (
                exercise: Int(ary[0]) ?? 0,
                repsExercise: Int(ary[1]) ?? 0,
                repsSet: Int(ary[2]) ?? 0,
                sets: Int(ary[3]) ?? 0,
                perRep: Int(ary[4]) ?? 0,
                betweenSets: Int(ary[5]) ?? 0,
                betweenExercices: Int(ary[6]) ?? 0
            )
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

    @IBAction func onPlayAction(_ sender: Any) {
        let vc = AppStoryboard.Workouts.viewController(viewControllerClass: WorkoutPlayVC.self)
        vc.workout = workout
        vc.exercises = exercises
        vc.meta = meta
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WorkoutExercisesVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return handleHeaderCell(tableView, cellForRowAt: indexPath)
        } else {
            return handleNormalCell(tableView, cellForRowAt: indexPath)
        }
    }

    fileprivate func handleHeaderCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutExerciseHeaderCell.identifier, for: indexPath) as? WorkoutExerciseHeaderCell else {
            fatalError()
        }

        var child: [UIView] = []
        if meta.exercise > 0 {
            child.append(metaItem(title: "Exercises".localized, value: "*\(meta.exercise)"))
        }
        if meta.repsExercise > 0 {
            child.append(metaItem(title: "Reps/Exercice".localized, value: meta.repsExercise.description))
        }
        if meta.repsSet > 0 {
            child.append(metaItem(title: "Reps/Set".localized, value: meta.repsSet.description))
        }
        if meta.sets > 0 {
            child.append(metaItem(title: "Sets".localized, value: meta.sets.description))
        }
        if meta.perRep > 0 {
            child.append(metaItem(title: "Per Rep".localized, value: "\(meta.perRep)s"))
        }
        if meta.betweenSets > 0 {
            child.append(metaItem(title: "Between sets".localized, value: "\(meta.betweenSets)s"))
        }
        if meta.betweenExercices > 0 {
            child.append(metaItem(title: "Between exercices".localized, value: "\(meta.betweenExercices)s"))
        }

        cell.setup(child)

        return cell
    }

    fileprivate func handleNormalCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutExerciseCell.identifier, for: indexPath) as? WorkoutExerciseCell else {
            fatalError()
        }

        let exercise = exercises[indexPath.row - 1]

        if let gif = UIImage.gif(name: "\(isMale ? "male" : "female")\(exercise.id)"), let first = gif.images?.first {
            cell.exerciseImage.image = first
        } else {
            cell.exerciseImage.image = UIImage(named: "ic_exercise")
        }
        cell.nameLabel.text = isEn ? exercise.enName : exercise.arName

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 56 : 100
    }
}
