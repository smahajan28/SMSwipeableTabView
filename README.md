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
swipeableView.titleBarDataSource = titleBarDataSource

//Assign your viewcontroller as delegate to load the Viewcontroller
swipeableView.delegate = self

//Set the View Frame (64.0 is 44.0(NavigationBar Height) + 20.0(StatusBar Height)
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
listVC.dataSource = anyArray[index]
return listVC
}
```
## Customization 

We can customize each and every control in this view. Just pass a dictionary with required fields.

e.g.:
If you want to change the background color of the top bar, just add the following code:
```swift
swipeableView.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.lightGrayColor()]

```

If you want to change the background color of the selection bar(Bar display under the segment button) and set Alpha of the selection bar, just add the following code:
```swift
swipeableView.selectionBarAttributes = [SMBackgroundColorAttribute : UIColor.greenColor(), SMAlphaAttribute : 0.8]

```

Also you can update the segment Button, you can add the following attribute keys in the dictionary

```swift
SMFontAttribute // Set UIFont insatance
SMForegroundColorAttribute  // Set UIColor instance
SMBackgroundColorAttribute // Set UIColor instance
SMAlphaAttribute // Set CGFloat value
SMBackgroundImageAttribute // Set UIImage instance
SMButtonNormalImageAttribute // Set UIImage instance
SMButtonHighlightedImageAttribute // Set UIImage instance
SMButtonHideTitleAttribute // Set Bool instance
```
## Author

Sahil Mahajan, sahilrameshmahajan@gmail.com

## License

SMSwipeableTabView is available under the MIT license. See the LICENSE file for more info.
