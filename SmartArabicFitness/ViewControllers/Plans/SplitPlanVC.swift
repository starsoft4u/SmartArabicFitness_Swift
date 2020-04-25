//
//  SplitPlanVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/30.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit

class SplitPlanVC: UIViewController {
    @IBOutlet weak var notesLabel: UILabel!

    @IBOutlet weak var exerciseButton1: UIButton!
    @IBOutlet weak var exerciseButton2: UIButton!
    @IBOutlet weak var exerciseButton3: UIButton!

    @IBOutlet weak var methodButton1: UIButton!
    @IBOutlet weak var methodButton2: UIButton!

    @IBOutlet weak var dayButton1: UIButton!
    @IBOutlet weak var dayButton2: UIButton!
    @IBOutlet weak var dayButton3: UIButton!

    var plan: Plans!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = plan.name?.localized
        notesLabel.text = plan.notes?.localized

        switch plan.id {
        case 4: [methodButton1, methodButton2, dayButton1, dayButton2, dayButton3].forEach { $0?.isHidden = true }
        case 5: [exerciseButton3.superview, methodButton1, methodButton2, dayButton1, dayButton2, dayButton3].forEach { $0?.isHidden = true }
        case 6: [exerciseButton1, exerciseButton2, exerciseButton3.superview, dayButton1, dayButton2, dayButton3].forEach { $0?.isHidden = true }
        case 7: [methodButton1, methodButton2, exerciseButton1, exerciseButton2, exerciseButton3.superview].forEach { $0?.isHidden = true }
        default: break
        }
    }

    @IBAction func onExerciseAction(_ sender: UIButton) {
        let vc = AppStoryboard.Plan.viewController(viewControllerClass: SplitPlanDetailVC.self)
        vc.navTitle = sender.title(for: .normal)
        switch sender.tag {
        case 0:
            if plan.id == 4 {
                vc.dataSource = [
                    (title: "Monday", detail: "Upper Body"),
                    (title: "Tuesday", detail: "Rest"),
                    (title: "Wednesday", detail: "Rest"),
                    (title: "Thursday", detail: "Lower Body"),
                    (title: "Friday", detail: "Rest"),
                    (title: "Saturday", detail: "Rest"),
                    (title: "Sunday", detail: "Rest"),
                ]
            } else {
                vc.dataSource = [
                    (title: "Monday", detail: "Feet"),
                    (title: "Tuesday", detail: "Rest"),
                    (title: "Wednesday", detail: "Back"),
                    (title: "Thursday", detail: "Rest"),
                    (title: "Friday", detail: "Chest"),
                    (title: "Saturday", detail: "Rest"),
                    (title: "Sunday", detail: "Rest"),
                ]
            }
        case 1:
            if plan.id == 4 {
                vc.dataSource = [
                    (title: "Monday", detail: "Upper Body"),
                    (title: "Tuesday", detail: "Lower Body"),
                    (title: "Wednesday", detail: "Rest"),
                    (title: "Thursday", detail: "Upper Body"),
                    (title: "Friday", detail: "Lower Body"),
                    (title: "Saturday", detail: "Rest"),
                ]
            } else {
                vc.dataSource = [
                    (title: "Monday", detail: "Feet"),
                    (title: "Tuesday", detail: "Back"),
                    (title: "Wednesday", detail: "Chest"),
                    (title: "Thursday", detail: "Feet"),
                    (title: "Friday", detail: "Back"),
                    (title: "Saturday", detail: "Chest"),
                    (title: "Sunday", detail: "Rest"),
                ]
            }
        case 2:
            vc.dataSource = [
                (title: "Monday", detail: "Upper Body"),
                (title: "Tuesday", detail: "Lower Body"),
                (title: "Wednesday", detail: "Upper Body"),
                (title: "Thursday", detail: "Lower Body"),
                (title: "Friday", detail: "Upper Body"),
                (title: "Saturday", detail: "Lower Body"),
                (title: "Sunday", detail: "Rest"),
            ]
        default:
            break
        }

        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onMethodAction(_ sender: UIButton) {
        let vc = AppStoryboard.Plan.viewController(viewControllerClass: SplitPlanDetailVC.self)
        vc.navTitle = sender.title(for: .normal)
        if sender.tag == 0 {
            vc.dataSource = [
                (title: "Monday", detail: "Feet"),
                (title: "Tuesday", detail: "Tricepts + Chest"),
                (title: "Wednesday", detail: "Rest"),
                (title: "Thursday", detail: "Biceps + Back"),
                (title: "Friday", detail: "Shoulders + Abs"),
                (title: "Saturday", detail: "Rest"),
                (title: "Sunday", detail: "Rest"),
            ]
        } else if sender.tag == 1 {
            vc.dataSource = [
                (title: "Monday", detail: "Chest"),
                (title: "Tuesday", detail: "Feet"),
                (title: "Wednesday", detail: "Back"),
                (title: "Thursday", detail: "Rest"),
                (title: "Friday", detail: "Arms"),
                (title: "Saturday", detail: "Shoulders"),
                (title: "Sunday", detail: "Rest"),
            ]
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func onDayAction(_ sender: UIButton) {
        let vc = AppStoryboard.Plan.viewController(viewControllerClass: SplitPlanDetailVC.self)
        if sender.tag == 0 {
            vc.navTitle = "Monday"
            vc.dataSource = [
                (title: "Bench Press", detail: "5 sets * 5 reps"),
                (title: "Squat", detail: "5 sets * 5 reps"),
                (title: "Ruden", detail: "5 sets * 5 reps"),
                (title: "Grunches", detail: "4 sets * 15–20 reps"),
                (title: "Dips", detail: "3 Sets * 15 Reps"),
            ]
        } else if sender.tag == 1 {
            vc.navTitle = "Wednesday"
            vc.dataSource = [
                (title: "Squat", detail: "5 sets * 5 reps"),
                (title: "Pull up", detail: "5 sets * 5 reps"),
                (title: "Deadlift", detail: "5 sets * 5 reps"),
                (title: "Bicepscurls", detail: "3 sets * 10–12 reps"),
                (title: "Shoulder Press", detail: "5 sets * 5 reps"),
            ]
        } else if sender.tag == 2 {
            vc.navTitle = "Friday"
            vc.dataSource = [
                (title: "Squat", detail: "5 sets * 5 reps"),
                (title: "Bench Press", detail: "5 sets * 5 reps"),
                (title: "Crunches", detail: "5 sets * 20 reps"),
                (title: "Dumbbell curls", detail: "3 sets * 15–12 reps"),
            ]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
