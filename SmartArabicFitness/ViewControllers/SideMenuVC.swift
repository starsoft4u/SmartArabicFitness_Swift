//
//  NavVC.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit
import SideMenuSwift

class SideMenuVC: SideMenuController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
