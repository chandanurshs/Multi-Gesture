//
//  ForceTouchRecognizer.swift
//  Trackpad
//
//  Created by Urs on 13/05/19.
//  Copyright © 2019 Urs. All rights reserved.
//

import AudioToolbox
import Foundation
import UIKit.UIGestureRecognizerSubclass

@available(iOS 9.0, *)
final class ForceTouchGestureRecognizer: UIGestureRecognizer {
    
    private let threshold: CGFloat = 0.75
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            handleTouch(touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            handleTouch(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = UIGestureRecognizer.State.failed
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = UIGestureRecognizer.State.failed
    }
    
    private func handleTouch(_ touch: UITouch) {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else { return }
        
        let impact = UIImpactFeedbackGenerator()
        if touch.force / touch.maximumPossibleForce >= threshold {
            state = UIGestureRecognizer.State.recognized
            //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            let model = UIDevice.modelName
            //print(model)
            if model == "iPhone 6s" || model == "iPhone 6s Plus"{
                //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }else{
                impact.impactOccurred()
            }
        }
    }
    
}

