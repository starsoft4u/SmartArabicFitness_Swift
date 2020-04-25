//
//  Helper.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    case Main, Exercices, SpecialInfos, Plan, Workouts, Logs, MoreInfos

    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardIdentifier = (viewControllerClass as UIViewController.Type)
        return instance.instantiateViewController(withIdentifier: "\(storyboardIdentifier)") as! T
    }
}

final class Defaults {
    struct lang: TSUD { static let defaultValue: String = "" }
    struct selectedMenuIndex: TSUD { static let defaultValue: Int = 1 }
    struct gender: TSUD { static let defaultValue: Int = -1 }
    struct age: TSUD { static let defaultValue: Int = 0 }
    struct weight: TSUD { static let defaultValue: Double = 0 }
    struct length: TSUD { static let defaultValue: Double = 0 }
    struct bodyType: TSUD { static let defaultValue: Int = 1 }
}

final class Constants {
    static let adsUnitId = "ca-app-pub-4911379124479428/4761152765"
    
    final class BodyMap {
        static let enMale = [
            CGRect(x: 0.275, y: 0.8485148515, width: 0.4203125, height: 0.0702970297), // All exercises
            CGRect(x: 0.1125, y: 0.300990099, width: 0.3015625, height: 0.06138613861), // Abs
            CGRect(x: 0.5828125, y: 0.2891089109, width: 0.3125, height: 0.05148514851), // Back
            CGRect(x: 0.096875, y: 0.7732673267, width: 0.3203125, height: 0.06336633663), // Cardio
            CGRect(x: 0.5890625, y: 0.2267326733, width: 0.321875, height: 0.05247524752), // Chest
            CGRect(x: 0.59375, y: 0.5356435644, width: 0.2890625, height: 0.06237623762), // Lower Legs
            CGRect(x: 0.575, y: 0.1524752475, width: 0.3015625, height: 0.06237623762), // Shoulders
            CGRect(x: 0.571875, y: 0.7643564356, width: 0.34375, height: 0.07425742574), // Stretch
            CGRect(x: 0.0359375, y: 0.1732673267, width: 0.3375, height: 0.05643564356), // Triceps
            CGRect(x: 0.09375, y: 0.4752475248, width: 0.2953125, height: 0.04851485149), // Upper Legs
            CGRect(x: 0.0375, y: 0.2435643564, width: 0.3265625, height: 0.04752475248), // Biceps
            CGRect(x: 0.6421875, y: 0.3514851485, width: 0.2375, height: 0.05841584158), // Forearm
        ]
        static let arMale = [
            CGRect(x: 0.2671875, y: 0.8564356436, width: 0.446875, height: 0.06633663366), // All exercises
            CGRect(x: 0.1015625, y: 0.3069306931, width: 0.3015625, height: 0.05940594059), // Abs
            CGRect(x: 0.5859375, y: 0.2891089109, width: 0.3015625, height: 0.05148514851), // Back
            CGRect(x: 0.09375, y: 0.7712871287, width: 0.359375, height: 0.06534653465), // Cardio
            CGRect(x: 0.5765625, y: 0.2257425743, width: 0.303125, height: 0.05544554455), // Chest
            CGRect(x: 0.5921875, y: 0.5425742574, width: 0.371875, height: 0.05148514851), // Lower Legs
            CGRect(x: 0.5859375, y: 0.1544554455, width: 0.3125, height: 0.05742574257), // Shoulders
            CGRect(x: 0.5765625, y: 0.7663366337, width: 0.353125, height: 0.07326732673), // Stretch
            CGRect(x: 0.0390625, y: 0.1326732673, width: 0.34375, height: 0.08316831683), // Triceps
            CGRect(x: 0.03125, y: 0.4772277228, width: 0.3390625, height: 0.05247524752), // Upper Legs
            CGRect(x: 0.0453125, y: 0.2277227723, width: 0.3109375, height: 0.06732673267), // Biceps
            CGRect(x: 0.6453125, y: 0.3504950495, width: 0.2375, height: 0.05445544554), // Forearm
        ]
        static let enFemale = [
            CGRect(x: 0.2734375, y: 0.8564356436, width: 0.4484375, height: 0.06534653465), // All exercises
            CGRect(x: 0.078125, y: 0.2801980198, width: 0.334375, height: 0.05643564356), // Abs
            CGRect(x: 0.546875, y: 0.2633663366, width: 0.3359375, height: 0.05247524752), // Back
            CGRect(x: 0.090625, y: 0.7752475248, width: 0.365625, height: 0.07425742574), // Cardio
            CGRect(x: 0.5703125, y: 0.201980198, width: 0.3171875, height: 0.05940594059), // Chest
            CGRect(x: 0.5484375, y: 0.4851485149, width: 0.3, height: 0.06336633663), // Lower Legs
            CGRect(x: 0.571875, y: 0.1316831683, width: 0.321875, height: 0.0504950495), // Shoulders
            CGRect(x: 0.5609375, y: 0.7643564356, width: 0.35, height: 0.08118811881), // Stretch
            CGRect(x: 0.078125, y: 0.1554455446, width: 0.3125, height: 0.05346534653), // Triceps
            CGRect(x: 0.0953125, y: 0.4485148515, width: 0.3140625, height: 0.05742574257), // Upper Legs
            CGRect(x: 0.0421875, y: 0.2168316832, width: 0.3515625, height: 0.05544554455), // Biceps
            CGRect(x: 0.6078125, y: 0.3188118812, width: 0.25625, height: 0.06138613861), // Forearm
            CGRect(x: 0.0921875, y: 0.3485148515, width: 0.325, height: 0.05841584158), // Glutes
        ]
        static let arFemale = [
            CGRect(x: 0.2671875, y: 0.8524752475, width: 0.446875, height: 0.07326732673), // All exercises
            CGRect(x: 0.0921875, y: 0.2782178218, width: 0.3296875, height: 0.06237623762), // Abs
            CGRect(x: 0.5578125, y: 0.2623762376, width: 0.321875, height: 0.05247524752), // Back
            CGRect(x: 0.1015625, y: 0.7683168317, width: 0.3609375, height: 0.06138613861), // Cardio
            CGRect(x: 0.553125, y: 0.200990099, width: 0.3375, height: 0.05940594059), // Chest
            CGRect(x: 0.5546875, y: 0.4871287129, width: 0.36875, height: 0.05742574257), // Lower Legs
            CGRect(x: 0.5765625, y: 0.1297029703, width: 0.2984375, height: 0.06237623762), // Shoulders
            CGRect(x: 0.553125, y: 0.7603960396, width: 0.371875, height: 0.08514851485), // Stretch
            CGRect(x: 0.0734375, y: 0.1059405941, width: 0.3265625, height: 0.09405940594), // Triceps
            CGRect(x: 0.0625, y: 0.4524752475, width: 0.3734375, height: 0.05940594059), // Upper Legs
            CGRect(x: 0.0515625, y: 0.2, width: 0.3328125, height: 0.06831683168), // Biceps
            CGRect(x: 0.6078125, y: 0.3237623762, width: 0.2609375, height: 0.05544554455), // Forearm
            CGRect(x: 0.096875, y: 0.3455445545, width: 0.315625, height: 0.05940594059), // Glutes
        ]
    }
}
