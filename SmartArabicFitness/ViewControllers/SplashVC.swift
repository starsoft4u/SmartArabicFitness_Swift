//
//  SplashVC.swift
//  SmartArabicFitness
//
//  Created by Eliot Gravett on 8/17/19.
//  Copyright © 2019 raptor. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var sloganImage: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        logoImage.alpha = 0
        sloganImage.alpha = 0
        UIView.animate(withDuration: 3, animations: {
            self.logoImage.alpha = 1
            self.sloganImage.alpha = 1
        }) { _ in
            if Defaults.gender.value < 0 {
                let vc = AppStoryboard.Main.viewController(viewControllerClass: GenderVC.self)
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                if self.traitCollection.horizontalSizeClass == .regular, self.traitCollection.verticalSizeClass == .regular {
                    let vc = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SplitVC")
                    self.present(vc, animated: true, completion: nil)
                } else {
                    let vc = AppStoryboard.Main.viewController(viewControllerClass: SideMenuVC.self)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
