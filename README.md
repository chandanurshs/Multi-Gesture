# Multi-Gestures
Multi-Gestures is a swift file which helps you add multiple gestures to the same UIView and use them simultaneously.

## Requirements

iOS 9.0 and later.
Xcode 9.0 and later.
Swift 4.1.

## Features

* Single tap(including multi touches and multi taps).
* Long press Gesture.
* Pan gesture (including multi touch).
* Pinch gesture.
* Force touch(iPhone 6s and higher devices).

## Usage

Add the file to your project.

Use it like below:

```swift

class viewController: UIViewController {

	var trackpad: Trackpad?
    @IBOutlet weak var trackpadView: UIView!
	trackpad = Trackpad(trackpad: trackpadView, trackpadGestureDelegate: self)
	
	###
}
extension ViewController: GestureDelegates{
    func gesture(gestureType: gestureType, noOfTouches: Int?, noOfTaps: Int?, coOrdinates: CGPoint?, transCoOrdinates: CGPoint?, scale: CGFloat?, panVelocity: CGPoint?, pinchVelocity: CGFloat?) {
		switch gestureType {
        case .tapGesture:
            if noOfTouches == 2 && noOfTaps == 1 {
                print("2 finger Tap", coOrdinates)
            }else if noOfTouches == 1 && noOfTaps == 2 {
                print("Double Tap", coOrdinates)
            }else if noOfTouches == 1 && noOfTaps == 1{
                print("Single Tap", coOrdinates)
            }
        case .panGesture:
            if noOfTouches == 1{
                print("1 finger pan")
            }else if noOfTouches == 2{
            print("2 finger pan")
            }else if noOfTouches == 3{
            print("3 finger pan")
            }
        case .tapAndHoldGesture:
            print("Long press")
        case .pinchGesture:
            print("Pinch gesture")
        case .forceTouchGesture:
            print("Force Touch")
        }
    }
}
```
