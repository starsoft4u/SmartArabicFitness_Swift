//
//  GenderVC.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import Toast_Swift
import UIKit

class GenderVC: UIViewController {
    var selectedIndex = -1
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var maleImage: UIImageView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var femaleImage: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setHidesBackButton(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAds()
        updateUI()
    }

    @IBAction func onFemaleAction(_ sender: Any) {
        selectedIndex = 0
        updateUI()
    }

    @IBAction func onMaleAciton(_ sender: Any) {
        selectedIndex = 1
        updateUI()
    }

    fileprivate func updateUI() {
        femaleView.backgroundColor = selectedIndex == 0 ? .orange : UIColor(rgb: 0xb4b5b0)
        femaleImage.image = selectedIndex == 0 ? #imageLiteral(resourceName: "ic_female_d") : #imageLiteral(resourceName: "ic_female")
        maleView.backgroundColor = selectedIndex == 1 ? .orange : UIColor(rgb: 0xb4b5b0)
        maleImage.image = selectedIndex == 1 ? #imageLiteral(resourceName: "ic_male_d") : #imageLiteral(resourceName: "ic_male")
    }

    @IBAction func onStartAction(_ sender: UIButton) {
        guard selectedIndex >= 0 else {
            view.makeToast("Please select gender".localized)
            return
        }

        Defaults.gender.value = selectedIndex

        if traitCollection.horizontalSizeClass == .regular, traitCollection.verticalSizeClass == .regular {
            let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SplitVC")
            present(vc, animated: true, completion: nil)
        } else {
            let vc = AppStoryboard.Main.viewController(viewControllerClass: SideMenuVC.self)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
