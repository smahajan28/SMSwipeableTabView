# SMSwipeableTabView

[![CI Status](http://img.shields.io/travis/Sahil Mahajan/SMSwipeableTabView.svg?style=flat)](https://travis-ci.org/Sahil Mahajan/SMSwipeableTabView)
[![Version](https://img.shields.io/cocoapods/v/SMSwipeableTabView.svg?style=flat)](http://cocoapods.org/pods/SMSwipeableTabView)
[![License](https://img.shields.io/cocoapods/l/SMSwipeableTabView.svg?style=flat)](http://cocoapods.org/pods/SMSwipeableTabView)
[![Platform](https://img.shields.io/cocoapods/p/SMSwipeableTabView.svg?style=flat)](http://cocoapods.org/pods/SMSwipeableTabView)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Demo: 
(Without Customization)


![demo](http://i.imgur.com/fOsNdck.gif)

## Installation

SMSwipeableTabView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SMSwipeableTabView"
```
## How to use 
(check out the provided Example):

We need to add the following code in the viewController where we need to implement this control.

```swift 
//Add the title bar elements as an Array of String
swipeableView.titleBarDataSource = titleBarDataSource //Array of Button Titles like ["Punjab", "Karnataka", "Mumbai"]

//Assign your viewcontroller as delegate to load the Viewcontroller
swipeableView.delegate = self

//Set the View Frame (64.0 is 44.0(NavigationBar Height) + 20.0(StatusBar Height))
swipeableView.view.frame = CGRectMake(0.0, 64.0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-64.0)

//Then add the view controller on the current view.
self.addChildViewController(swipeableView)
self.view.addSubview(swipeableView.view)
swipeableView.didMoveToParentViewController(self)
```

## Delegate Callback

Whenever you click on any segment button or swipe the page on the controller. Delegate method will return the next viewcontroller to load

```Swift
func didLoadViewControllerAtIndex(index: Int) -> UIViewController {
    //We can implement switch case with the index Parameter and load new controller at every new index. Or we can load the same list view with different datasource.
    let listVC = UIViewController()
    listVC.backgroundColor = UIColor.redColor()
    listVC.dataSource = anyArray[index] // This will be an array of arrays or we need to set our dataSource of every different controller.
    return listVC
}
```
## Customization 

We can customize each and every control in this view. Just pass a dictionary with required fields.

NOTE: Set the frame of swipeableViewController after setting all the attributes.

e.g.:
If you want to change the background color of the top bar, just add the following code:
```swift
swipeableView.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.lightGrayColor()]

```

If you want to change the background color of the selection bar(Bar display under the segment button) and set Alpha of the selection bar, just add the following code:
```swift
swipeableView.selectionBarAttributes = [
                                        SMBackgroundColorAttribute : UIColor.greenColor(), 
                                        SMAlphaAttribute : 0.8
                                        ]

```

Also you can update the segment Button, just add attributes for button:
```swift
// Setting Font And BackgroundColor of Button
swipeableView.buttonAttributes = [
                                    SMBackgroundColorAttribute : UIColor.greenColor(), 
                                    SMAlphaAttribute : 0.8,
                                    SMFontAttribute : UIFont(name: "HelveticaNeue-Medium", size: 13.0)
                                 ]
```

if you want to add images instead of Title in buttons, you can easily set Normal and Highlighted Image attribute in the dictionary, like

```swift
// Setting Font And BackgroundColor of Button
// Here for Normal and Highlighted Images we need to send the imageName array
swipeableView.buttonAttributes = [
                                    SMBackgroundColorAttribute : UIColor.clearColor(), 
                                    SMAlphaAttribute : 0.8,
                                    SMButtonHideTitleAttribute : true,
                                    SMButtonNormalImagesAttribute :["image_name1", "image_name2"] as [String]),
                                    SMButtonHighlightedImagesAttribute : ["high_image_name1", "high_image_name2"] as [String])
                                 ]
```

you can add the following attribute keys in the dictionary

```swift
SMFontAttribute // Set UIFont insatance
SMForegroundColorAttribute  // Set UIColor instance (e.g. : Button Title Label ForegroundColor)
SMBackgroundColorAttribute // Set UIColor instance
SMAlphaAttribute // Set CGFloat value
SMBackgroundImageAttribute // Set UIImage instance
SMButtonNormalImageAttribute // Set UIImage instance
SMButtonHighlightedImageAttribute // Set UIImage instance
SMButtonHideTitleAttribute // Set Bool instance
```

Width of selectionBar is highly customizable. We can make the width fix or variabele.

```swift
swipeableView.buttonWidth = 60.0
```

Similarly Height of selectionBar can be changed using

```swift
swipeableView.selectionBarHeight = 2.0 //For thin line
```

We can also change the height of the segmentBar, use the below line of code:

```swift
swipeableView.segementBarHeight = 50.0 //Default is 44.0
```

Padding in the button can be customised using:

```swift
swipeableView.buttonPadding = 10.0 //Default is 8.0
```

## Customized App Demo
(With Customization)

![demo](http://i.imgur.com/oMVnz36.gif)

## Author

Sahil Mahajan, sahilrameshmahajan@gmail.com

## License

SMSwipeableTabView is available under the MIT license. See the LICENSE file for more info.
