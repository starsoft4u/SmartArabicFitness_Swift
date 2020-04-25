//
//  SpecialInfosVC.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/19.
//  Copyright © 2018 raptor. All rights reserved.
//

import BEMCheckBox
import DropDown
import UIKit

class SpecialInfosVC: UIViewController {
    @IBOutlet var checkBoxes: [BEMCheckBox]!
    @IBOutlet var stackViews: [UIStackView]!

    @IBOutlet weak var ageView: UITextField!
    @IBOutlet weak var weightView: UITextField!
    @IBOutlet weak var lenghtView: UITextField!

    @IBOutlet weak var caloriesSexLabel: UILabel!
    @IBOutlet weak var calogiesAgeLabel: UILabel!
    @IBOutlet weak var caloriesWeightLabel: UILabel!
    @IBOutlet weak var caloriesLengthLabel: UILabel!
    @IBOutlet weak var caloriesActivityButton: UIButton!
    @IBOutlet weak var caloriesResultLabel: UILabel!

    @IBOutlet weak var fatAbdomenText: UITextField!
    @IBOutlet weak var fatHipText: UITextField!
    @IBOutlet weak var fatNeckText: UITextField!
    @IBOutlet weak var fatHeightText: UITextField!
    @IBOutlet weak var fatResultLabel: UILabel!

    @IBOutlet weak var bmiWeightLabel: UILabel!
    @IBOutlet weak var bmiLengthLabel: UILabel!
    @IBOutlet weak var bmiHands: UIView!

    @IBOutlet var bodyTypeButtons: [UIButton]!

    var bmiHandsDegree: CGFloat = CGFloat.pi / 2
    let activities: [(name: String, value: Double)] = [
        (name: "Sedentary activity", value: 1.2),
        (name: "Light activity", value: 1.375),
        (name: "Moderatley activity", value: 1.55),
        (name: "Very activity", value: 1.725),
        (name: "Extremely activity", value: 1.9),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        makeMenu()

        // Load data
        let age = Defaults.age.value
        let weight = Defaults.weight.value
        let length = Defaults.length.value

        ageView.text = age == 0 ? "" : age.description
        weightView.text = weight == 0 ? "" : weight.description
        lenghtView.text = length == 0 ? "" : length.description
        calogiesAgeLabel.text = age == 0 ? "" : age.description
        [caloriesWeightLabel, bmiWeightLabel].forEach { $0.text = weight == 0 ? "" : "\(weight)kg" }
        [caloriesLengthLabel, bmiLengthLabel].forEach { $0.text = length == 0 ? "" : "\(length)cm" }
        caloriesSexLabel.text = isMale ? "Sex.Man".localized : "Sex.Woman".localized
        caloriesActivityButton.setTitle(activities[caloriesActivityButton.tag].name.localized, for: .normal)
        bodyTypeButtons.forEach { styleButton($0, selected: $0.tag == Defaults.bodyType.value) }

        // Hide all items
        (0...6).forEach { selectCell(at: $0, selected: false) }

        rotateCaloiresHands(degree: 0)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let spliteVC = splitViewController else { return }
        hasMenu = spliteVC.displayMode == .allVisible
    }

    fileprivate func styleButton(_ button: UIButton, selected: Bool) {
        button.backgroundColor = selected ? .orange : .grey
        button.tintColor = selected ? .white : .lightBlack
    }

    fileprivate func selectCell(at index: Int, selected: Bool = true) {
        // Show/hide
        if selected {
            checkBoxes.forEach { $0.on = $0.tag == index }
            stackViews.forEach { stackView in
                stackView.arrangedSubviews.enumerated().forEach { $1.isHidden = $0 > 0 && stackView.tag != index }
            }
        } else {
            checkBoxes.filter { $0.tag == index }.first?.on = false
            stackViews.filter { $0.tag == index }.first?.arrangedSubviews.enumerated().forEach { $1.isHidden = $0 > 0 }
        }

        if isMale {
            fatHipText.superview?.superview?.isHidden = true
        }

        // Shadow
        view.layoutIfNeeded()

        if selected {
            checkBoxes.forEach { $0.superview?.shadow(top: $0.tag == index && index > 0, bottom: $0.tag == index) }
        } else {
            checkBoxes.filter { $0.tag == index }.first?.superview?.shadow(top: false, bottom: false)
        }
    }

    @IBAction func onSelectCellAction(_ sender: UIButton) {
        view.endEditing(true)
        
        let checked = checkBoxes.filter { $0.tag == sender.tag }.first?.on ?? true
        guard !checked else { return }

        selectCell(at: sender.tag)
    }

    @IBAction func onCancelAction(_ sender: UIButton) {
        selectCell(at: sender.tag, selected: false)
        view.endEditing(true)
    }

    @IBAction func saveAgeAction(_ sender: UIButton) {
        if let age = Int(ageView.text!) {
            Defaults.age.value = age
            calogiesAgeLabel.text = age.description
            selectCell(at: 0, selected: false)
        } else {
            Defaults.age.value = 0
            ageView.text = ""
            calogiesAgeLabel.text = ""
        }
        view.endEditing(true)
    }

    @IBAction func saveWeightAction(_ sender: Any) {
        if let weight = Double(weightView.text!) {
            Defaults.weight.value = weight
            [caloriesWeightLabel, bmiWeightLabel].forEach { $0.text = "\(weight.toString())kg" }
            selectCell(at: 1, selected: false)
        } else {
            Defaults.weight.value = 0
            weightView.text = ""
            [caloriesWeightLabel, bmiWeightLabel].forEach { $0.text = "" }
        }
        view.endEditing(true)
    }

    @IBAction func saveLengthAction(_ sender: Any) {
        if let length = Double(lenghtView.text!) {
            Defaults.length.value = length
            [caloriesLengthLabel, bmiLengthLabel].forEach { $0.text = "\(length.toString())cm" }
            selectCell(at: 2, selected: false)
        } else {
            Defaults.length.value = 0
            lenghtView.text = ""
            [caloriesLengthLabel, bmiLengthLabel].forEach { $0.text = "" }
        }
        view.endEditing(true)
    }

    /*
     * Sedentary activity       1.2
     * Light activity           1.375
     * Moderatley activity      1.55
     * Very activity            1.725
     * Extremely activity       1.9
     */
    @IBAction func onPhysicalActivityAction(_ sender: UIButton) {
        let dropDown = DropDown(anchorView: sender)
        dropDown.dataSource = activities.map { $0.name.localized }
        dropDown.selectRow(sender.tag)
        dropDown.selectionAction = { index, item in
            sender.tag = index
            sender.setTitle(item, for: .normal)
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

    /*
     * Formula
     * Man: 66 + ( 13.7*weight in kg) + ( 5  length in cm) - (6.8 age in years) * activity
     * Woman: 655+ ( 9.6*weight in kg) + ( 1.8  length in cm) - (4.7 age in years) * activity
     */
    @IBAction func calculateCaloriesAction(_ sender: Any) {
        guard Defaults.weight.value > 0, Defaults.length.value > 0, Defaults.age.value > 0 else {
            return
        }

        var calories: Double = 0
        if Defaults.gender.value == 1 {
            // man
            calories = Double(66) +
                (Double(13.7) * Defaults.weight.value) +
                (Double(5) * Defaults.length.value) -
                (Double(6.8) * Double(Defaults.age.value) * activities[caloriesActivityButton.tag].value)
        } else {
            // woman
            calories = Double(655) +
                (Double(9.6) * Defaults.weight.value) +
                (Double(1.8) * Defaults.length.value) -
                (Double(4.7) * Double(Defaults.age.value) * activities[caloriesActivityButton.tag].value)
        }

        caloriesResultLabel.text = calories.toString()
        view.endEditing(true)
    }

    /*
     * Formula
     * Man  :  Weight (kg)  /  2(Length in meters)
     * Woman: Same?
     */
    @IBAction func calculateBMIAction(_ sender: Any) {
        guard Defaults.weight.value > 0, Defaults.length.value > 0 else {
            return
        }

        let bmi = Defaults.weight.value * Double(100) / Defaults.length.value
        print("bmi = \(bmi)")
        switch bmi {
        case let x where x < 18: rotateCaloiresHands(degree: 0)
        case 18..<25: rotateCaloiresHands(degree: CGFloat.pi / 8)
        case 25..<30: rotateCaloiresHands(degree: CGFloat.pi * 3 / 8)
        case 30..<40: rotateCaloiresHands(degree: CGFloat.pi * 5 / 8)
        case let x where x > 40: rotateCaloiresHands(degree: CGFloat.pi * 7 / 8)
        default: break
        }
        
        view.endEditing(true)
    }

    /*
     * Formula
     * Man  : %Fat = 96.010 * LOG(abdomen - neck) - 70.041 * LOG(height) + 30.30
     * Woman: %Fat = 163.205 * LOG(abdomen + hip - neck) - 97.684 * LOG(height) - 78.387
     */
    @IBAction func calculateBodyFatAction(_ sender: Any) {
        if isMale {
            guard let t1 = fatAbdomenText.text, let abdomen = Double(t1),
                let t2 = fatNeckText.text, let neck = Double(t2),
                let t3 = fatHeightText.text, let height = Double(t3) else {
                return
            }

            let fat = 96.01 * log(abdomen - neck) - 70.041 * log(height) + 30.3
            print("fat = \(fat)")
            fatResultLabel.text = String(format: "%.2f", fat)
        } else {
            guard let t1 = fatAbdomenText.text, let abdomen = Double(t1),
                let t2 = fatNeckText.text, let neck = Double(t2),
                let t3 = fatHeightText.text, let height = Double(t3),
                let t4 = fatHipText.text, let hip = Double(t4) else {
                return
            }

            let fat = 163.205 * log(abdomen + hip - neck) - 97.684 * log(height) - 78.387
            print("fat = \(fat)")
            fatResultLabel.text = String(format: "%.2f", fat)
        }
        view.endEditing(true)
    }

    @IBAction func onBodyTypeAction(_ sender: UIButton) {
        Defaults.bodyType.value = sender.tag
        bodyTypeButtons.forEach { styleButton($0, selected: $0.tag == sender.tag) }
        view.endEditing(true)
    }

    @IBAction func onBodyTypeDetailAction(_ sender: UIButton) {
        let vc = AppStoryboard.SpecialInfos.viewController(viewControllerClass: BodyTypeVC.self)
        vc.type = sender.tag
        navigationController?.pushViewController(vc, animated: true)
    }

    fileprivate func rotateCaloiresHands(degree: CGFloat) {
        let offset = degree - bmiHandsDegree
        guard offset != 0 else { return }

        bmiHandsDegree = degree

        UIView.animate(withDuration: 1, animations: {
            self.bmiHands.transform = self.bmiHands.transform.rotated(by: offset)
        })
    }
}
