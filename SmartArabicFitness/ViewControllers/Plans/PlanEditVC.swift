//
//  PlanEditVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/25.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit
import BEMCheckBox
import CoreStore

class PlanEditVC: UIViewController {
    @IBOutlet var checkBoxes: [BEMCheckBox]!
    @IBOutlet var stackViews: [UIStackView]!

    @IBOutlet weak var nameView: UITextField!
    @IBOutlet weak var notesView: UITextField!

    var plan: Plans?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAds()

        if let plan = plan {
            navigationItem.title = "Edit Plan".localized

            nameView.text = plan.name
            notesView.text = plan.notes
        } else {
            navigationItem.title = "Create New Plan".localized
        }

        selectCell(at: 0)
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

        // Shadow
        view.layoutIfNeeded()

        if selected {
            checkBoxes.forEach { $0.superview?.shadow(top: $0.tag == index && index > 0, bottom: $0.tag == index) }
        } else {
            checkBoxes.filter { $0.tag == index }.first?.superview?.shadow(top: false, bottom: false)
        }

    }

    @IBAction func onSelectCellAction(_ sender: UIButton) {
        let checked = checkBoxes.filter { $0.tag == sender.tag }.first?.on ?? true
        guard !checked else { return }

        selectCell(at: sender.tag)
    }

    @IBAction func onSaveAction(_ sender: Any) {
        let name = nameView.text
        let notes = notesView.text

        if let _ = plan {
            CoreStore.perform(
                asynchronous: { transaction in
                    let plan = transaction.edit(self.plan)
                    plan?.name = name
                    plan?.notes = notes
                },
                completion: { _ in
                    self.performSegue(withIdentifier: "unwind2Plans", sender: nil)
                }
            )
        } else {
            CoreStore.perform(
                asynchronous: { transaction in
                    let maxId = try transaction.queryValue(From<Plans>().select(Int64.self, .maximum(\.id))) ?? 0
                    let plan = transaction.create(Into<Plans>())
                    plan.id = maxId + 1
                    plan.name = name
                    plan.notes = notes
                    plan.isDefault = false
                },
                completion: { _ in
                    self.performSegue(withIdentifier: "unwind2Plans", sender: nil)
                }
            )
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
