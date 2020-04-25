//
//  MenuVC.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit
import Cartography

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
}

class MenuVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let menuItems: [(icon: String, title: String)] = [
        (icon: "ic_remove_ads", title: "Remove ads"),
        (icon: "ic_exercices", title: "Exercices"),
        (icon: "ic_specialinfo", title: "Special infos"),
        (icon: "ic_plan", title: "My plan"),
        (icon: "ic_workouts", title: "Workouts"),
        (icon: "ic_history", title: "Logs"),
        (icon: "ic_more", title: "More"),
    ]

    var viewControllers: [Int: UIViewController] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Menu
        viewControllers = [
            1: AppStoryboard.Exercices.instance.instantiateInitialViewController()!,
            2: AppStoryboard.SpecialInfos.instance.instantiateInitialViewController()!,
            3: AppStoryboard.Plan.instance.instantiateInitialViewController()!,
            4: AppStoryboard.Workouts.instance.instantiateInitialViewController()!,
            5: AppStoryboard.Logs.instance.instantiateInitialViewController()!,
            6: AppStoryboard.MoreInfos.instance.instantiateInitialViewController()!,
        ]
        viewControllers.forEach { key, value in
            sideMenuController?.cache(viewController: value, with: key.description)
        }

        let nib = UINib(nibName: MenuItemCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MenuItemCell.identifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.constraints.forEach { $0.isActive = false }
        if splitViewController == nil {
            tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
            tableView.isScrollEnabled = false
            constrain(tableView) {
                $0.top == $0.superview!.top
                $0.trailing == $0.superview!.trailing
                $0.bottom == $0.superview!.bottom
                $0.width == 240
            }
        } else {
            tableView.isScrollEnabled = true
            constrain(tableView) {
                $0.leading == $0.superview!.leading
                $0.top == $0.superview!.top
                $0.trailing == $0.superview!.trailing
                $0.bottom == $0.superview!.bottom
            }
        }

        // Load VC relevant selected menu
        if let split = splitViewController {
            split.showDetailViewController(viewControllers[Defaults.selectedMenuIndex.value]!, sender: nil)
        } else if let sideMenu = sideMenuController {
            sideMenu.setContentViewController(with: Defaults.selectedMenuIndex.value.description)
        }
    }
}

extension MenuVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as? MenuItemCell else {
            fatalError("Unable to dequeue resuable cell for MenuItemCell")
        }

        cell.icon.image = UIImage(named: menuItems[indexPath.row].icon)
        cell.icon.highlightedImage = UIImage(named: "\(menuItems[indexPath.row].icon)_d")
        cell.title.text = menuItems[indexPath.row].title.localized

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            // remove ads
        } else {
            Defaults.selectedMenuIndex.value = indexPath.row
            if let splitVC = splitViewController {
                let vc = viewControllers[indexPath.row]!
                splitVC.showDetailViewController(vc, sender: nil)
                if splitVC.displayMode == .primaryOverlay {
                    splitVC.toggleMasterView()
                }
            } else if let sideMenu = sideMenuController {
                sideMenu.setContentViewController(with: indexPath.row.description)
                sideMenu.hideMenu()
            }
        }
    }
}
