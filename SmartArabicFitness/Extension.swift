//
//  Extensions.swift
//  Smart Arabic Fitness
//
//  Created by raptor on 2018/8/18.
//  Copyright © 2018 raptor. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import Cartography

extension Double {
    func toString() -> String {
        return String(format: "%g", self)
    }
}

extension NSObject {
    class var dynamicClassFullName: String {
        return NSStringFromClass(self)
    }
    
    class var dynamicClassName: String {
        let p = dynamicClassFullName
        let r = p.range(of: ".")!
        return String(p[r.upperBound...])
    }
    
    var dynamicTypeFullName: String {
        return NSStringFromClass(type(of: self))
    }
    
    var dynamicTypeName: String {
        let p = dynamicTypeFullName
        let r = p.range(of: ".")!
        return String(p[r.upperBound...])
    }
}

extension UIViewController {
    var isEn: Bool {
        return Defaults.lang.value == "en"
    }
    
    var isMale: Bool {
        return Defaults.gender.value == 1
    }
    
    var statusBarBackgroundColor: UIColor? {
        get {
            return view.viewWithTag(99)?.backgroundColor
        }
        set {
            if let statusBarView = view.viewWithTag(99) {
                statusBarView.backgroundColor = newValue
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.backgroundColor = statusBarBackgroundColor
                statusBarView.tag = 99
                view.addSubview(statusBarView)
                view.sendSubviewToBack(statusBarView)
            }
        }
    }
    
    func makeMenu() {
        if let splitVC = splitViewController, splitVC.displayMode == .allVisible {
            hasMenu = false
        } else {
            hasMenu = true
        }
    }
    
    var hasMenu: Bool {
        get {
            return navigationItem.leftBarButtonItem != nil
        }
        set {
            if newValue {
                let menuBtn = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(onMenuAction(_:)))
                navigationItem.leftBarButtonItem = menuBtn
            } else {
                navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    @objc func onMenuAction(_ sender: UIBarButtonItem) {
        if let splitVC = splitViewController {
            splitVC.toggleMasterView()
        } else {
            sideMenuController?.revealMenu()
        }
    }
    
    func alert(icon: UIImage? = nil, message: String, positiveTitle: String = "OK", positiveAction: (() -> Void)? = nil, negativeTitle: String? = nil, negativeAction: (() -> Void)? = nil) {
        ///
    }
    
    func setupAds() {
        guard let container = view.subviews.filter({ $0.tag == 99 }).first, container.subviews.isEmpty else { return }
        
//        constrain(container) {
//            $0.height == 0
//        }
        
        let adView = GADBannerView(adSize: kGADAdSizeBanner)
        adView.adUnitID = Constants.adsUnitId
        adView.rootViewController = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adView.load(request)

        container.addSubview(adView)
        constrain(adView) {
            $0.leading == $0.superview!.leading
            $0.trailing == $0.superview!.trailing
            $0.top == $0.superview!.top
            $0.bottom == $0.superview!.bottom
        }
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { return UIColor(cgColor: layer.shadowColor!) }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable var shadowSize: CGFloat {
        get { return layer.shadowOffset.height }
        set { layer.shadowOffset = CGSize(width: 0, height: newValue) }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = min(newValue, 1) }
    }
    
    open class var nibName: String {
        return self.dynamicClassName
    }
    
    open class var identifier: String {
        return nibName
    }
    
    func shadow(top: Bool, bottom: Bool) {
        guard top || bottom else {
            layer.masksToBounds = true
            superview?.sendSubviewToBack(self)
            return
        }
        
        layer.masksToBounds = false
        superview?.bringSubviewToFront(self)
        
        let shadowSize: CGFloat = 6
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.2
        if top, bottom {
            layer.shadowPath = UIBezierPath(rect: CGRect(
                x: 0,
                y: -shadowSize / 2,
                width: frame.size.width,
                height: frame.size.height + shadowSize)).cgPath
        } else if top {
            layer.shadowPath = UIBezierPath(rect: CGRect(
                x: 0,
                y: -shadowSize / 2,
                width: frame.size.width,
                height: frame.size.height + shadowSize / 2)).cgPath
        } else {
            layer.shadowPath = UIBezierPath(rect: CGRect(
                x: 0,
                y: 0,
                width: frame.size.width,
                height: frame.size.height + shadowSize / 2)).cgPath
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF)
    }
    
    open class var orange: UIColor { return UIColor(rgb: 0xF68C1C) }
    open class var darkOrange: UIColor { return UIColor(rgb: 0xFB6C00) }
    open class var grey: UIColor { return UIColor(rgb: 0xF4F5F8) }
    open class var lightBlack: UIColor { return UIColor(rgb: 0x1F2124) }
}

extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}
