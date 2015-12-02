//
//  UIView+InterruptibleTapGestureRecognizer.swift
//  GestureTest
//
//  Created by HeYilei on 3/12/2015.
//  Copyright © 2015 jEyLaBs. All rights reserved.
//

import UIKit

var touchResponsibleRange:CGFloat = 80.0

@objc public protocol InterruptibleTapDelegate{
    optional func viewPressed(view:UIView!)
    optional func viewNotPressed(view:UIView!)
    optional func action(view:UIView!)
}

public extension UIView {
    private struct AssociatedKeys {
        static var delegateKey = "delegate"
    }
    
    private var interruptibleTapdelegate:InterruptibleTapDelegate! {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.delegateKey) as? InterruptibleTapDelegate
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.delegateKey, newValue as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    func addInterruptibleTapGestureRecognizerWithDelegate(delegate:InterruptibleTapDelegate){
        self.interruptibleTapdelegate = delegate
        self.userInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: "viewTapped:")
        longPress.minimumPressDuration = 0.01
        self.addGestureRecognizer(longPress)
    }
    
    @objc private func viewTapped(gestureRecognizer:UILongPressGestureRecognizer){
        struct staticVariables{
            static var startLocation:CGPoint = CGPointZero
            static var distance:CGFloat = 0.0
        }
        switch gestureRecognizer.state {
        case .Began:
            self.interruptibleTapdelegate.viewPressed?(gestureRecognizer.view)
            staticVariables.startLocation = gestureRecognizer.locationInView(nil)
            staticVariables.distance = 0.0
        case.Changed:
            if CGPointEqualToPoint(staticVariables.startLocation, CGPointZero) {
                return
            }
            let currentLocation = gestureRecognizer.locationInView(nil)
            staticVariables.distance = hypot(staticVariables.startLocation.x - currentLocation.x, staticVariables.startLocation.y - currentLocation.y)
            if staticVariables.distance > touchResponsibleRange {
                self.interruptibleTapdelegate.viewNotPressed?(gestureRecognizer.view)
            }else{
                self.interruptibleTapdelegate.viewPressed?(gestureRecognizer.view)
            }
        case.Ended:
            self.interruptibleTapdelegate.viewNotPressed?(gestureRecognizer.view)
            if staticVariables.distance < touchResponsibleRange {
                self.interruptibleTapdelegate.action?(gestureRecognizer.view)
            }
        default:
            self.interruptibleTapdelegate.viewNotPressed?(gestureRecognizer.view)
        }
    }
}
