//
//  Trackpad.swift
//  Trackpad
//
//  Created by Urs on 10/05/19.
//  Copyright © 2019 Urs. All rights reserved.
//

import Foundation
import UIKit


public enum gestureType{
    case tapGesture
    case panGesture
    case tapAndHoldGesture
    case pinchGesture
    case forceTouchGesture
}

protocol GestureDelegates {
    func gesture(gestureType: gestureType, noOfTouches: Int?, noOfTaps: Int?, coOrdinates: CGPoint?, transCoOrdinates: CGPoint?, scale: CGFloat?, panVelocity: CGPoint?, pinchVelocity: CGFloat?)
}

class Trackpad {
    var trackpadView: UIView!
    
    var trackpadGestureDelegate: GestureDelegates?
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(trackpadViewTapped(recognizer:)))
    
    lazy var twoFingertapGesture = UITapGestureRecognizer(target: self, action: #selector(trackpadViewTapped(recognizer:)))
    
    lazy var doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(trackpadViewTapped(recognizer:)))
    
    lazy var panGesture = UIPanGestureRecognizer(target: self, action: #selector(trackpadViewPanned(_ :)))
    
    lazy var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapAndHold(recognizer:)))
    
    lazy var pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(trackpadviewPinched(recognizer:)))
    
    lazy var forceTouchGesture = ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchHandler(recognizer:)))
    
    var didPanEnd = true
    
    var didPinchEnd = true
    
    init(trackpad: UIView, trackpadGestureDelegate: GestureDelegates) {
        self.trackpadView = trackpad
        self.trackpadGestureDelegate = trackpadGestureDelegate
        self.trackpadView.backgroundColor = .lightGray
        self.trackpadView.isMultipleTouchEnabled = true
        
        if self.trackpadGestureDelegate != nil{
            setupGestures()
        }else{
            print("trackpadGestureDelegate is empty.")
        }
    }
    
    private func setupGestures(){
        
        doubleTapGesture.numberOfTapsRequired = 2
        self.trackpadView.addGestureRecognizer(doubleTapGesture)
        
        twoFingertapGesture.numberOfTouchesRequired = 2
        self.trackpadView.addGestureRecognizer(twoFingertapGesture)
        
        tapGesture.numberOfTapsRequired = 1
        self.trackpadView.addGestureRecognizer(tapGesture)

        tapGesture.require(toFail: twoFingertapGesture)
        tapGesture.require(toFail: doubleTapGesture)
        tapGesture.require(toFail: longPressGesture)
        
        self.trackpadView.addGestureRecognizer(panGesture)
        
        longPressGesture.minimumPressDuration = 1
        self.trackpadView.addGestureRecognizer(longPressGesture)
        
        self.trackpadView.addGestureRecognizer(pinchGesture)
        
        self.trackpadView.addGestureRecognizer(forceTouchGesture)
        
        panGesture.require(toFail: tapGesture)
        
        if trackpadView.superview?.traitCollection.forceTouchCapability == UIForceTouchCapability.available{
            self.trackpadView.addGestureRecognizer(forceTouchGesture)
        }else{
            self.trackpadView.removeGestureRecognizer(forceTouchGesture)
        }
        
    }
    
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return false
    }
    
    @objc private func trackpadViewTapped(recognizer: UITapGestureRecognizer){
        
        let location = recognizer.location(in: self.trackpadView)
        
        if recognizer.numberOfTouchesRequired == 2 {
            trackpadGestureDelegate?.gesture(gestureType: .tapGesture, noOfTouches: 2, noOfTaps: 1, coOrdinates: location, transCoOrdinates: nil, scale: CGFloat.zero, panVelocity: nil, pinchVelocity: nil)
        }else if recognizer.numberOfTapsRequired == 2{
            trackpadGestureDelegate?.gesture(gestureType: .tapGesture, noOfTouches: 1, noOfTaps: 2, coOrdinates: location, transCoOrdinates: nil, scale: nil, panVelocity: nil, pinchVelocity: nil)
        }else if recognizer.numberOfTouchesRequired == 1{
            trackpadGestureDelegate?.gesture(gestureType: .tapGesture, noOfTouches: 1, noOfTaps: 1, coOrdinates: location, transCoOrdinates: nil, scale: nil, panVelocity: nil, pinchVelocity: nil)
        }
    }
    
    
    @objc private func trackpadViewPanned(_ recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self.trackpadView)
        let location = recognizer.location(in: self.trackpadView)
        let velocity = recognizer.velocity(in: self.trackpadView)

        print(recognizer.numberOfTouches)
        
        if recognizer.state == .began{
            
            didPanEnd = false
            
        }else if recognizer.state == .changed && didPinchEnd && (translation.x >= 2.0 || translation.y >= 2.0 || translation.x <= -2.0 || translation.y <= -2.0  ){
            if recognizer.numberOfTouches == 1{
                trackpadGestureDelegate?.gesture(gestureType: .panGesture, noOfTouches: 1, noOfTaps: nil, coOrdinates: location, transCoOrdinates: translation, scale: nil, panVelocity: velocity, pinchVelocity: nil)
            }else if recognizer.numberOfTouches == 2 && didPinchEnd && (translation.x >= 2.0 || translation.y >= 2.0 || translation.x <= -2.0 || translation.y <= -2.0  ){
                trackpadGestureDelegate?.gesture(gestureType: .panGesture, noOfTouches: 2, noOfTaps: nil, coOrdinates: location, transCoOrdinates: translation, scale: nil, panVelocity: velocity, pinchVelocity: nil)
            }else if recognizer.numberOfTouches == 3 && didPinchEnd && (translation.x >= 2.0 || translation.y >= 2.0 || translation.x <= -2.0 || translation.y <= -2.0  ){
                trackpadGestureDelegate?.gesture(gestureType: .panGesture, noOfTouches: 3, noOfTaps: nil, coOrdinates: location, transCoOrdinates: translation, scale: nil, panVelocity: velocity, pinchVelocity: nil)
            }
        }else if recognizer.state == .ended{
            didPanEnd = true
        }
        
    }
    
    @objc private func tapAndHold(recognizer: UISwipeGestureRecognizer){
        
        if recognizer.state == .began{
            
            let location = recognizer.location(in: self.trackpadView)
            
            trackpadGestureDelegate?.gesture(gestureType: .tapAndHoldGesture, noOfTouches: 1, noOfTaps: 1, coOrdinates: location, transCoOrdinates:  nil, scale: nil, panVelocity: nil, pinchVelocity: nil)
        }
        
    }
    
    @objc private func trackpadviewPinched(recognizer: UIPinchGestureRecognizer){
        
        
        if recognizer.state == .began{
            didPinchEnd = false
        }
        else if recognizer.numberOfTouches == 2 && didPanEnd && recognizer.state == .changed && (recognizer.scale >= 1.15 || recognizer.scale >= 0.85) && recognizer.velocity != 0 {
            trackpadGestureDelegate?.gesture(gestureType: .pinchGesture, noOfTouches: nil, noOfTaps: nil, coOrdinates: nil, transCoOrdinates: nil, scale: recognizer.scale, panVelocity: nil, pinchVelocity: recognizer.velocity)
        }else if recognizer.state == .ended{
            didPinchEnd = true
        }
    }

    @objc func forceTouchHandler(recognizer: ForceTouchGestureRecognizer) {
        
        let location = recognizer.location(in: self.trackpadView)
        
        trackpadGestureDelegate?.gesture(gestureType: .forceTouchGesture, noOfTouches: 1, noOfTaps: 1, coOrdinates: location, transCoOrdinates: nil, scale: nil, panVelocity: nil, pinchVelocity: nil)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
    }
    

}

