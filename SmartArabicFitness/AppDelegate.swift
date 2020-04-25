//
//  AppDelegate.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/17.
//  Copyright © 2018 raptor. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import SideMenuSwift
import SwiftyJSON
import Localize
import CoreStore
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Default menu
        Defaults.selectedMenuIndex.value = 1
        
        // Language
        if Defaults.lang.value.isEmpty {
            Defaults.lang.value = Locale.current.languageCode == "ar" ? "ar" : "en"
        }
        
        // Localization
        Localize.update(provider: .json)
        Localize.update(fileName: "lang")
        Localize.update(defaultLanguage: Defaults.lang.value)
        UIView.appearance().semanticContentAttribute = Defaults.lang.value == "en" ? .forceLeftToRight : .forceRightToLeft
        
        // Keyboard
        IQKeyboardManager.shared.enable = true
        
        // Side menu
        SideMenuController.preferences.basic.position = .above
        SideMenuController.preferences.basic.menuWidth = 240
        SideMenuController.preferences.basic.enablePanGesture = false
        SideMenuController.preferences.basic.direction = Defaults.lang.value == "en" ? .left : .right
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = false
        
        // Dropdown
        DropDown.startListeningToKeyboard()
        
        // Ads
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // Core data
        CoreStore.defaultStack = DataStack(xcodeModelName: "SmartArabicFitness")
        do {
            try CoreStore.addStorageAndWait()
        } catch {
            print("Failed to initialize CoreStore with \(error.localizedDescription)")
        }
        
        preloadData()
        
        return true
    }
    
    // MARK: - Core Data Saving support
    
    func preloadData() {
        guard let path = Bundle.main.path(forResource: "data", ofType: "json") else { return }
        
        do {
            let muscleCount = try CoreStore.fetchCount(From<Muscles>())
            guard muscleCount == 0 else { return }
            
            // Load json
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try JSON(data: data)
            
            // Insert muscles
            CoreStore.perform(
                asynchronous: { transaction in
                    
                    try transaction.deleteAll(From<Muscles>())
                    json["muscles"].arrayValue.forEach { item in
                        let muscle = transaction.create(Into<Muscles>())
                        muscle.id = item["id"].int64Value
                        muscle.enName = item["en"].stringValue
                        muscle.arName = item["ar"].stringValue
                    }
                    
                    try transaction.deleteAll(From<Exercices>())
                    json["exercices"].arrayValue.forEach { item in
                        let exercise = transaction.create(Into<Exercices>())
                        exercise.id = item["id"].int64Value
                        exercise.muscleId = item["muscleId"].int64Value
                        exercise.isPremium = item["premium"].boolValue
                        exercise.gender = item["gender"].string
                        
                        exercise.enName = item["en", "name"].string
                        exercise.enType = item["en", "type"].string
                        exercise.enEquipment = item["en", "equipment"].string
                        exercise.enDifficulty = item["en", "difficulty"].string
                        exercise.enHowTo = item["en", "howto"].string
                        exercise.enMainGroup = item["en", "mainGroup"].string
                        exercise.enOtherGroup = item["en", "otherGroup"].string
                        
                        exercise.arName = item["ar", "name"].string
                        exercise.arType = item["ar", "type"].string
                        exercise.arEquipment = item["ar", "equipment"].string
                        exercise.arDifficulty = item["ar", "difficulty"].string
                        exercise.arHowTo = item["ar", "howto"].string
                        exercise.arMainGroup = item["ar", "mainGroup"].string
                        exercise.arOtherGroup = item["ar", "otherGroup"].string
                    }
                    
                    try transaction.deleteAll(From<Plans>())
                    json["plans"].arrayValue.forEach { item in
                        let plan = transaction.create(Into<Plans>())
                        plan.id = item["id"].int64Value
                        plan.name = item["name"].string
                        plan.notes = item["notes"].string
                        plan.isDefault = true
                    }
                    
                    try transaction.deleteAll(From<PlanExercices>())
                    json["planExercices"].arrayValue.forEach { item in
                        let planExercise = transaction.create(Into<PlanExercices>())
                        planExercise.id = item["id"].int64Value
                        planExercise.planId = item["planId"].int64Value
                        planExercise.exerciseId = item["exerciseId"].int64Value
                    }
                    
                    try transaction.deleteAll(From<Workouts>())
                    json["workouts"].arrayValue.forEach { item in
                        let workout = transaction.create(Into<Workouts>())
                        workout.id = item["id"].int64Value
                        workout.price = item["price"].doubleValue
                        workout.isPurchased = item["isPurchased"].boolValue
                        workout.gender = item["gender"].string
                        workout.levelCount = item["levelCount"].int64Value
                        workout.level1 = item["level1"].stringValue
                        workout.level2 = item["level2"].stringValue
                        
                        workout.enName = item["en", "name"].string
                        workout.enGoal = item["en", "goal"].string
                        workout.enLevel = item["en", "level"].string
                        workout.enEquipment = item["en", "equipment"].string
                        workout.enDescription = item["en", "description"].string
                        workout.enInstruction = item["en", "instruction"].string
                        
                        workout.arName = item["ar", "name"].string
                        workout.arGoal = item["ar", "goal"].string
                        workout.arLevel = item["ar", "level"].string
                        workout.arEquipment = item["ar", "equipmart"].string
                        workout.arDescription = item["ar", "description"].string
                        workout.arInstruction = item["ar", "instruction"].string
                    }
                    
                    try transaction.deleteAll(From<WorkoutExercises>())
                    json["workoutsExercises"].arrayValue.forEach { item in
                        let workoutExercise = transaction.create(Into<WorkoutExercises>())
                        workoutExercise.id = item["id"].int64Value
                        workoutExercise.workoutId = item["workoutId"].int64Value
                        workoutExercise.exerciseId = item["exerciseId"].int64Value
                        workoutExercise.level = item["level"].int64Value
                    }
                    
                    try transaction.deleteAll(From<Logs>())
            },
                completion: { _ in }
            )
            
        } catch {
            print("Failed to preload data from json")
        }
    }
}
