//
//  BodyTypeVC.swift
//  SmartArabicFitness
//
//  Created by Eliot Gravett on 8/18/19.
//  Copyright © 2019 raptor. All rights reserved.
//

import SwiftyAttributes
import UIKit

class BodyTypeVC: UIViewController {
    @IBOutlet weak var ectomorphView: UIView!
    @IBOutlet weak var mesomorphView: UIView!
    @IBOutlet weak var endomorphView: UIView!
    
    @IBOutlet weak var detailLabel1: UILabel!
    @IBOutlet weak var detailLabel2: UILabel!
    @IBOutlet weak var detailLabel3: UILabel!
    @IBOutlet weak var detailLabel4: UILabel!
    
    var type = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var key = ""
        if type == 0 {
            title = "Ectomorph".localized
            key = "Ectomorph Detail"
            mesomorphView.alpha = 0.5
            endomorphView.alpha = 0.5
        } else if type == 1 {
            title = "Mesomorph".localized
            key = "Mesomorph Detail"
            ectomorphView.alpha = 0.5
            endomorphView.alpha = 0.5
        } else {
            title = "Endomorph".localized
            key = "Endomorph Detail"
            ectomorphView.alpha = 0.5
            mesomorphView.alpha = 0.5
        }
        
        detailLabel1.attributedText =
            "\(key)1.title".localized.withTextColor(.orange).withFont(UIFont.systemFont(ofSize: 15, weight: .semibold)) +
            "\(key)1.detail".localized.withTextColor(.darkGray).withFont(UIFont.systemFont(ofSize: 15))
        detailLabel1.sizeToFit()
        detailLabel2.attributedText =
            "\(key)2.title".localized.withTextColor(.orange).withFont(UIFont.systemFont(ofSize: 15, weight: .semibold)) +
            "\(key)2.detail".localized.withTextColor(.darkGray).withFont(UIFont.systemFont(ofSize: 15))
        detailLabel2.sizeToFit()
        detailLabel3.attributedText =
            "\(key)3.title".localized.withTextColor(.orange).withFont(UIFont.systemFont(ofSize: 15, weight: .semibold)) +
            "\(key)3.detail".localized.withTextColor(.darkGray).withFont(UIFont.systemFont(ofSize: 15))
        detailLabel3.sizeToFit()
        detailLabel4.attributedText =
            "\(key)4.title".localized.withTextColor(.orange).withFont(UIFont.systemFont(ofSize: 15, weight: .semibold)) +
            "\(key)4.detail".localized.withTextColor(.darkGray).withFont(UIFont.systemFont(ofSize: 15))
        detailLabel4.sizeToFit()
        
        view.layoutIfNeeded()
        
        detailLabel1.superview?.shadow(top: true, bottom: true)
        detailLabel2.superview?.shadow(top: true, bottom: true)
        detailLabel3.superview?.shadow(top: true, bottom: true)
        detailLabel4.superview?.shadow(top: true, bottom: true)
        
        if !isEn {
            [detailLabel1,detailLabel2,detailLabel3,detailLabel4].forEach {
                $0?.semanticContentAttribute = .forceRightToLeft
            }
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
