//
//  MusclesVC.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit

class MusclesVC: UIViewController {
    @IBOutlet weak var bodyImage: UIImageView!

    var planId: Int64 = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        var body = isMale ? "body_man" : "body_woman"
        if !isEn {
            body = "\(body)_ar"
        }
        bodyImage.image = UIImage(named: body)

        if planId == 0 {
            makeMenu()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if let spliteVC = splitViewController, planId == 0 {
            hasMenu = spliteVC.displayMode == .allVisible
        }
    }

    @IBAction func onGestureAction(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }

        // Calculate offset
        let imageRatio: CGFloat = 640 / 1010
        let screenRatio = view.frame.width / view.frame.height
        var width = view.frame.width
        var height = view.frame.height

        var offset = CGPoint.zero
        if imageRatio > screenRatio {
            height = view.frame.width / imageRatio
            offset = CGPoint(x: 0, y: (view.frame.height - height) / 2)
        } else if imageRatio < screenRatio {
            width = view.frame.height * imageRatio
            offset = CGPoint(x: (view.frame.width - width) / 2, y: 0)
        }

        // Touch point
        var point = sender.location(in: view)
        point = CGPoint(x: (point.x - offset.x) / width, y: (point.y - offset.y) / height)

        // Find match
        var data = [CGRect]()
        if isEn {
            data = isMale ? Constants.BodyMap.enMale : Constants.BodyMap.enFemale
        } else {
            data = isMale ? Constants.BodyMap.arMale : Constants.BodyMap.arFemale
        }
        for (index, rect) in data.enumerated() {
            if rect.contains(point) {
                muscleSelected(index)
                break
            }
        }
    }

    fileprivate func muscleSelected(_ index: Int) {
        let vc = AppStoryboard.Exercices.viewController(viewControllerClass: ExercicesVC.self)
        vc.muscleId = index
        vc.planId = planId
        navigationController?.pushViewController(vc, animated: true)
    }
}
