//
//  WorkoutResultVC.swift
//  SmartArabicFitness
//
//  Created by Eliot Gravett on 8/20/19.
//  Copyright © 2019 raptor. All rights reserved.
//

import UIKit

class WorkoutResultVC: UIViewController {
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var workout: String?
    var exerciseCount = 0
    var sets = 0
    var time = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        workoutLabel.text = workout
        exerciseLabel.text = "*\(exerciseCount)"
        setsLabel.text = sets.description
        timeLabel.text = "\(time / 60):\(time % 60)"
    }

    @IBAction func onCloseAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
