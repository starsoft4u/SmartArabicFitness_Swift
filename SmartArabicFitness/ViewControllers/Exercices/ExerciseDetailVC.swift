//
//  ExerciseDetailVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/22.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit
import CoreStore
import DropDown
import Localize

class ExerciseDetailVC: UIViewController {
    @IBOutlet weak var mainMuscleLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var otherMuscleLabel: UILabel!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var stepsLabel: UILabel!

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!

    var planExercise: PlanExercices?
    var planId: Int64 = 0
    var exercise: Exercices!

    var sets: Int = 3
    var reps: Int = 4
    var rest: Int = 100
    var weight: Int = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAds()

        navigationItem.title = isEn ? exercise.enName : exercise.arName

        if let str = isEn ? exercise.enDifficulty : exercise.arDifficulty {
            difficultyLabel.text = "Difficulty:".localize(value: str)
        } else {
            difficultyLabel.isHidden = true
        }
        if let str = isEn ? exercise.enEquipment : exercise.arEquipment {
            equipmentLabel.text = "Equipment:".localize(value: str)
        } else {
            equipmentLabel.isHidden = true
        }
        if let str = isEn ? exercise.enMainGroup : exercise.arMainGroup {
            mainMuscleLabel.text = "Main Muscle Group:".localize(value: str)
        } else {
            do {
                if let muscle = try CoreStore.fetchOne(From<Muscles>().where(\.id == exercise.muscleId)) {
                    let str = isEn ? muscle.enName! : muscle.arName!
                    mainMuscleLabel.text = "Main Muscle Group:".localize(value: str)
                } else {
                    mainMuscleLabel.isHidden = true
                }
            } catch {
                mainMuscleLabel.isHidden = true
            }
        }
        if let str = isEn ? exercise.enOtherGroup : exercise.arOtherGroup {
            otherMuscleLabel.text = "Other Muscle Group:".localize(value: str)
        } else {
            otherMuscleLabel.isHidden = true
        }

        stepsLabel.text = isEn ? exercise.enHowTo : exercise.arHowTo
        stepsLabel.sizeToFit()

        exerciseImage.image = UIImage.gif(name: "\(isMale ? "male" : "female")\(exercise.id)") ?? UIImage(named: "exercise")

        if planId > 2 {
            infoView.isHidden = false

            if let planExercise = planExercise {
                sets = Int(planExercise.sets)
                reps = Int(planExercise.reps)
                rest = Int(planExercise.rest)
                weight = Int(planExercise.weight)
            }

            setsLabel.text = sets.description
            repsLabel.text = reps.description
            restTimeLabel.text = rest.description
            weightLabel.text = weight.description

            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(onAddExerciseToPlan))
        } else {
            infoView.isHidden = true
        }
    }

    @objc fileprivate func onAddExerciseToPlan() {
        if let planExercise = planExercise {
            CoreStore.perform(
                asynchronous: { transaction in
                    let item = transaction.edit(planExercise)
                    item?.sets = Int64(self.sets)
                    item?.reps = Int64(self.reps)
                    item?.rest = Int64(self.rest)
                    item?.weight = Int64(self.weight)
                },
                completion: { _ in
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "unwind2PlanExercices", sender: nil)
                    }
                }
            )
        } else if planId > 0 {
            CoreStore.perform(
                asynchronous: { transaction in
                    do {
                        let data = try transaction.queryValue(From<PlanExercices>().select(Int64.self, .maximum(\.id)))
                        let maxId = data ?? 0
                        let item = transaction.create(Into<PlanExercices>())
                        item.id = maxId + 1
                        item.sets = Int64(self.sets)
                        item.reps = Int64(self.reps)
                        item.rest = Int64(self.rest)
                        item.weight = Int64(self.weight)
                        item.planId = self.planId
                        item.exerciseId = self.exercise.id
                    } catch {
                        print(error)
                    }
                },
                completion: { _ in
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "unwind2PlanExercices", sender: nil)
                    }
                }
            )
        }
    }

    @IBAction func onSetsAction(_ sender: UIButton) {
        let dropDown = DropDown(anchorView: sender)
        dropDown.dataSource = (1...50).map { $0.description }
        dropDown.selectRow(sets - 1)
        dropDown.selectionAction = { [unowned self] index, item in
            self.sets = index + 1
            self.setsLabel.text = item
        }
        dropDown.show()
    }

    @IBAction func onRepsAction(_ sender: UIButton) {
        let dropDown = DropDown(anchorView: sender)
        dropDown.dataSource = (1...100).map { $0.description }
        dropDown.selectRow(reps - 1)
        dropDown.selectionAction = { [unowned self] index, item in
            self.reps = index + 1
            self.repsLabel.text = item
        }
        dropDown.show()
    }

    @IBAction func onRestTimeAction(_ sender: UIButton) {
        let dropDown = DropDown(anchorView: sender)
        dropDown.dataSource = (1...180).map { $0.description }
        dropDown.selectRow(rest - 1)
        dropDown.selectionAction = { [unowned self] index, item in
            self.rest = index + 1
            self.restTimeLabel.text = item
        }
        dropDown.show()
    }

    @IBAction func onWeightAction(_ sender: UIButton) {
        let dropDown = DropDown(anchorView: sender)
        dropDown.dataSource = (1...500).map { $0.description }
        dropDown.selectRow(weight - 1)
        dropDown.selectionAction = { [unowned self] index, item in
            self.weight = index + 1
            self.weightLabel.text = item
        }
        dropDown.show()
    }
}
