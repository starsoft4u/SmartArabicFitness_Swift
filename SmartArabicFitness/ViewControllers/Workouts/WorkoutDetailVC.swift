//
//  WorkoutDetailVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/9/13.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit

class WorkoutDetailVC: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var level1Button: UIButton!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var level2Button: UIButton!

    var workout: Workouts!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAds()

        title = isEn ? workout.enName : workout.arName

        if isEn {
            descriptionLabel.text = workout.enDescription
            goalLabel.text = workout.enGoal
            levelLabel.text = workout.enLevel
            equipmentLabel.text = workout.enEquipment
            instructionLabel.text = workout.enInstruction
        } else {
            descriptionLabel.text = workout.arDescription
            goalLabel.text = workout.arGoal
            levelLabel.text = workout.arLevel
            equipmentLabel.text = workout.arEquipment
            instructionLabel.text = workout.arInstruction
        }

        level1Button.titleLabel?.numberOfLines = 0
        level1Button.titleLabel?.textAlignment = .center
        level1Button.setTitle("Level 1".localized, for: .normal)

        if workout.levelCount == 1 {
            level2Button.isHidden = true
            separator.isHidden = true
        } else {
            level2Button.titleLabel?.numberOfLines = 0
            level2Button.titleLabel?.textAlignment = .center
            level2Button.setTitle("Level 2".localized, for: .normal)
        }
    }

    @IBAction func onLevelAction(_ sender: UIButton) {
        let vc = AppStoryboard.Workouts.viewController(viewControllerClass: WorkoutExercisesVC.self)
        vc.workout = workout
        vc.level = Int64(sender.tag)
        navigationController?.pushViewController(vc, animated: true)
    }
}
