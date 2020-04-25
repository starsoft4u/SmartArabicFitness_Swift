//
//  MoreInfoVC.swift
//  SmartArabicFitness
//
//  Created by raptor on 2018/8/22.
//  Copyright © 2018 raptor. All rights reserved.
//

import BEMCheckBox
import Localize
import SideMenuSwift
import UIKit

class MoreInfoVC: UIViewController {
    @IBOutlet var checkBoxes: [BEMCheckBox]!
    @IBOutlet var hideCells: [UIView]!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var arabicButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        makeMenu()
        setupAds()

        refreshLanguageButtons()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        guard let spliteVC = splitViewController else { return }
        hasMenu = spliteVC.displayMode == .allVisible
    }

    fileprivate func selectCell(at index: Int, selected: Bool = true) {
        // Show/hide
        if selected {
            checkBoxes.forEach { $0.on = $0.tag == index }
            hideCells.forEach { $0.isHidden = $0.tag != index }
        } else {
            checkBoxes.filter { $0.tag == index }.first?.on = false
        }

        // Shadow
        view.layoutIfNeeded()

        if selected {
            checkBoxes.forEach { $0.superview?.shadow(top: $0.tag == index && index > 0, bottom: $0.tag == index) }
        } else {
            checkBoxes.filter { $0.tag == index }.first?.superview?.shadow(top: false, bottom: false)
        }
    }

    fileprivate func refreshLanguageButtons() {
        englishButton.backgroundColor = isEn ? .orange : .grey
        englishButton.tintColor = isEn ? .white : .lightBlack

        arabicButton.backgroundColor = !isEn ? .orange : .grey
        arabicButton.tintColor = !isEn ? .white : .lightBlack
    }

    @IBAction func onSelectCellAction(_ sender: UIButton) {
        selectCell(at: sender.tag)
    }

    @IBAction func onLanguageAction(_ sender: UIButton) {
        guard (sender == englishButton && Defaults.lang.value != "en") || (sender == arabicButton && Defaults.lang.value != "ar") else {
            return
        }

        if sender === englishButton {
            Localize.update(language: "en")
            Defaults.lang.value = "en"
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            SideMenuController.preferences.basic.direction = .left
        } else if sender === arabicButton {
            Localize.update(language: "ar")
            Defaults.lang.value = "ar"
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            SideMenuController.preferences.basic.direction = .right
        }

        refreshLanguageButtons()

        Defaults.selectedMenuIndex.value = 6
        
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else {
            return
        }
        
        if let split = splitViewController {
            split.dismiss(animated: true, completion: nil)
            rootVC.topViewController?.present(AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SplitVC"), animated: true, completion: nil)
        } else if let nav = sideMenuController?.navigationController {
            nav.viewControllers.removeLast()
            nav.viewControllers.append(AppStoryboard.Main.viewController(viewControllerClass: SideMenuVC.self))
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
