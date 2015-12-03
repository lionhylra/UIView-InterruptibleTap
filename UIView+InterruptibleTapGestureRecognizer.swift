//
//  UIView+InterruptibleTapGestureRecognizer.swift
//  GestureTest
//
//  Created by HeYilei on 3/12/2015.
//  Copyright © 2015 jEyLaBs. All rights reserved.
//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Yilei He, lionhylra.com
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


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
            objc_setAssociatedObject(self, &AssociatedKeys.delegateKey, newValue as AnyObject, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
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
