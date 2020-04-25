//
//  WorkoutsVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/9/13.
//  Copyright © 2018 raptor. All rights reserved.
//

import CoreStore
import UIKit

class WorkoutCell: UITableViewCell {
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var lockView: UIView!
}

class WorkoutsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var workouts: [Workouts] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        makeMenu()
        setupAds()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        loadWorkouts()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let spliteVC = splitViewController else { return }
        hasMenu = spliteVC.displayMode == .allVisible
    }

    fileprivate func loadWorkouts() {
        do {
            let gender = isMale ? "female" : "male"
            let query = From<Workouts>().where(\.gender != gender).orderBy(.ascending(\.id))
            workouts = try CoreStore.fetchAll(query)
        } catch {
            workouts = []
        }
    }
}

extension WorkoutsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? WorkoutCell else {
            fatalError("Unable to dequeue reusable cell with identifier WorkoutCell")
        }

        let workout = workouts[indexPath.row]

        if isMale {
            cell.workoutImage.image = UIImage(named: "workout_\(workout.id)") ?? UIImage(named: "ic_exercise")
        } else if workout.id == 1 {
            cell.workoutImage.image = UIImage(named: "workout_7") ?? UIImage(named: "ic_exercise")
        } else {
            cell.workoutImage.image = UIImage(named: "workout_\(workout.id + 1)") ?? UIImage(named: "ic_exercise")
        }

        cell.nameLabel.text = isEn ? workout.enName : workout.arName
        cell.goalLabel.text = isEn ? workout.enGoal : workout.arGoal
        cell.lockView.isHidden = workout.isPurchased
        cell.selectionStyle = workout.isPurchased ? .default : .none
        cell.isUserInteractionEnabled = workout.isPurchased

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = AppStoryboard.Workouts.viewController(viewControllerClass: WorkoutDetailVC.self)
        vc.workout = workouts[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
