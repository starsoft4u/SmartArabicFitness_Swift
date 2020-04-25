//
//  WorkoutPlayVC.swift
//  SmartArabicFitness
//
//  Created by Eliot Gravett on 8/20/19.
//  Copyright © 2019 raptor. All rights reserved.
//

import UIKit
import Cartography
import SimpleAnimation
import UICircularProgressRing
import AVFoundation

class WorkoutPlayVC: UIViewController {
    @IBOutlet weak var progressStack: UIStackView!
    
    @IBOutlet weak var playPanel: UIView!
    @IBOutlet weak var exerciseImage: UIImageView!
    @IBOutlet weak var descPanelHeight: NSLayoutConstraint!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var exerciseDetailLabel: UILabel!
    
    @IBOutlet weak var restPanel: UIView!
    @IBOutlet weak var timeView: UICircularProgressRing!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nextExerciseLabel: UILabel!
    @IBOutlet weak var nextExerciseImage: UIImageView!
    
    let panelMinHeight = CGFloat(180)
    var panelMaxHeight = CGFloat(420)
    
    var workout: Workouts!
    var exercises: [Exercices] = []
    var meta: WorkoutMeta!
    var exerciseIndex = 0
    
    var restTimer: Timer?
    var consumeTimer: Timer?
    var consumeSeconds = 0
    
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = isEn ? workout.enName : workout.arName
        
        restPanel.isHidden = true
        
        let exercise = exercises[exerciseIndex]
        exerciseNameLabel.text = isEn ? exercise.enName : exercise.arName
        exerciseDetailLabel.text = isEn ? exercise.enHowTo : exercise.arHowTo
        (exerciseDetailLabel.superview as? UIScrollView)?.isScrollEnabled = false
        
        // start from overlay
        let overlay = UIView()
        let countLabel = UILabel()
        countLabel.textColor = .white
        countLabel.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
        
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        overlay.addSubview(countLabel)
        constrain(countLabel) {
            $0.centerX == $0.superview!.centerX
            $0.centerY == $0.superview!.centerY
        }
        
        view.addSubview(overlay)
        view.bringSubviewToFront(overlay)
        constrain(overlay) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.bottom == $0.superview!.bottom
        }
        
        var seconds = 5
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if seconds < 0 {
                timer.invalidate()
                overlay.fadeOut(duration: 0.3, delay: 0.0, completion: { _ in
                    self.start()
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(self.onNextAction))
                })
                self.consumeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.consumeSeconds += 1
                })
            } else if seconds == 0 {
                countLabel.text = "Start".localized
            } else {
                countLabel.text = "\(seconds)s"
            }
            seconds -= 1
        }
    }
    
    fileprivate func start() {
        setupProgress(success: 0..<exerciseIndex, current: exerciseIndex, remain: (exerciseIndex + 1)..<exercises.count)
        
        let exercise = exercises[exerciseIndex]
        let res = isMale ? "male\(exercise.id)" : "female\(exercise.id)"
        exerciseImage.image = UIImage.gif(name: res)
        exerciseNameLabel.text = isEn ? exercise.enName : exercise.arName
        exerciseDetailLabel.text = isEn ? exercise.enHowTo : exercise.arHowTo
        
        playSound(res)
        
        descPanelHeight.constant = panelMinHeight
        view.layoutIfNeeded()
    }
    
    fileprivate func setupProgress(success: Range<Int>?, current: Int?, remain: Range<Int>?) {
        let color = UIColor(rgb: 0xDDDDDD)
        
        if progressStack.arrangedSubviews.isEmpty {
            (0..<exercises.count).forEach { _ in
                let view = UIView()
                view.backgroundColor = color
                progressStack.addArrangedSubview(view)
            }
        }
        
        success?.forEach { progressStack.arrangedSubviews[$0].backgroundColor = .orange }
        remain?.forEach { progressStack.arrangedSubviews[$0].backgroundColor = color }
        
        if let current = current, 0..<exercises.count ~= current {
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.repeat, .autoreverse], animations: {
                self.progressStack.arrangedSubviews[current].backgroundColor = .orange
                self.progressStack.arrangedSubviews[current].backgroundColor = color
            }, completion: nil)
        } else {
            progressStack.arrangedSubviews.forEach { $0.layer.removeAllAnimations() }
        }
    }
    
    fileprivate func presentRestPanel() {
        setupProgress(success: 0..<exerciseIndex, current: nil, remain: nil)
        
        timeView.minValue = 0
        timeView.maxValue = CGFloat(meta.betweenExercices)
        timeView.value = timeView.maxValue
        timeLabel.text = "\(Int(timeView.value))s"
        
        let exercise = exercises[exerciseIndex]
        nextExerciseLabel.text = isEn ? exercise.enName : exercise.arName
        if let gif = UIImage.gif(name: "\(isMale ? "male" : "female")\(exercise.id)"), let first = gif.images?.first {
            nextExerciseImage.image = first
        } else {
            nextExerciseImage.image = UIImage(named: "ic_exercise")
        }
        
        restPanel.layoutIfNeeded()
        
        restPanel.slideIn(from: .bottom)
        
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeView.value -= 1
            if self.timeView.value < 0 {
                self.presentPlayPanel()
            } else {
                self.timeLabel.text = "\(Int(self.timeView.value))s"
            }
        }
        
        navigationItem.rightBarButtonItem = nil
    }
    
    fileprivate func presentPlayPanel() {
        restTimer?.invalidate()
        start()
        restPanel.slideOut(to: .bottom)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(onNextAction))
    }
    
    @IBAction func onSwipeUpAction(_ sender: UISwipeGestureRecognizer) {
        descPanelHeight.constant = panelMaxHeight
        UIView.animate(withDuration: 0.3) { self.playPanel.layoutIfNeeded() }
        (exerciseDetailLabel.superview as? UIScrollView)?.isScrollEnabled = true
    }
    
    @IBAction func onSwipeDownAction(_ sender: UISwipeGestureRecognizer) {
        descPanelHeight.constant = panelMinHeight
        UIView.animate(withDuration: 0.3) { self.playPanel.layoutIfNeeded() }
        (exerciseDetailLabel.superview as? UIScrollView)?.isScrollEnabled = false
    }
    
    @objc fileprivate func onNextAction() {
        exerciseIndex += 1
        
        guard exerciseIndex < exercises.count else {
            consumeTimer?.invalidate()
            
            let vc = AppStoryboard.Workouts.viewController(viewControllerClass: WorkoutResultVC.self)
            vc.workout = isEn ? workout.enName : workout.arName
            vc.exerciseCount = exercises.count
            vc.sets = meta.sets
            vc.time = consumeSeconds
            present(vc, animated: true, completion: nil)
            
            navigationController?.popViewController(animated: false)
            
            return
        }
        
        if descPanelHeight.constant == panelMaxHeight {
            descPanelHeight.constant = panelMinHeight
            UIView.animate(withDuration: 0.3, animations: {
                self.playPanel.layoutIfNeeded()
            }) { _ in
                self.presentRestPanel()
            }
        } else {
            presentRestPanel()
        }
    }
    
    @IBAction func onSkipAction(_ sender: Any) {
        presentPlayPanel()
    }
    
    func playSound(_ res: String?) {
        guard let url = Bundle.main.url(forResource: res, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player?.stop()
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.play()
        } catch {
            print(error)
        }
    }
}
