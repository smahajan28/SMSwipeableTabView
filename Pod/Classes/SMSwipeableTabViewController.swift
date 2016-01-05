//
//  SMSwipeableTabViewController.swift
//  SMSwipeableTabView
//
//  Created by Sahil Mahajan on 21/12/15.
//  Copyright © 2015 Sahil Mahajan. All rights reserved.
//

import UIKit


/// Attribute Dictionary Keys. These keys are used to customize the UI elements of View.

/**
Take UIFont as value. Set font of Tab button titleLabel Font.
*/
public let SMFontAttribute = "kFontAttribute"

/**
Take UIColor as value. Set color of Tab button titleLabel Font.
*/
public let SMForegroundColorAttribute = "kForegroundColorAttribute"

/**
Take UIColor as value. Set background color of any View.
*/
public let SMBackgroundColorAttribute = "kBackgroundColorAttribute"

/// Take CGFlaot as value. Set alpha of any View.
public let SMAlphaAttribute = "kAlphaAttribute"

/// Take UIImage as value. Set image of any View.
public let SMBackgroundImageAttribute = "kBackgroundImageAttribute"

/// Take Array of Strings(image_name) as value. Set button image for normal state.
public let SMButtonNormalImagesAttribute = "kButtonNormalImageAttribute"

/// Take Array of Strings(image_name) as value. Set button image for highlighted state.
public let SMButtonHighlightedImagesAttribute = "kButtonHighlightedImageAttribute"

/// Take Bool as value. Set title label of tab bar button hidden.
public let SMButtonHideTitleAttribute = "kButtonShowTitleAttribute" // Set Bool instance

/// Swipe constant
public let kSelectionBarSwipeConstant: CGFloat = 3.0

public protocol SMSwipeableTabViewControllerDelegate {
    func didLoadViewControllerAtIndex(index: Int) -> UIViewController
}

public class SMSwipeableTabViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    /// To set the height of segment bar(Top swipable tab bar).
    public var segementBarHeight: CGFloat = 44.0
    
    /// To set the margin beteen the buttons or tabs in the scrollable tab bar
    public var buttonPadding: CGFloat = 8.0
    
    /// To set the fixed width of the button/tab in the tab bar
    public var buttonWidth: CGFloat?
    
    /** To set the height of the selection bar
        Selection bar can be seen under the tab
    */
    public var selectionBarHeight: CGFloat = 4.0
    
    /** To set the background color of the tab bar.
        Default color is blue color. You can change the color as per your need.
    */
    public let defaultSegmentBarBgColor = UIColor.blueColor()
    
    /** To set the background color of the selection bar.
        Default color is red color. You can change the color as per your need.
    */
    public let defaultSelectionBarBgColor = UIColor.redColor()

    ///Dictionary to set button attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
    - Usage:
    buttonAttributes = [
                            SMBackgroundColorAttribute : UIColor.clearColor(),
                            SMAlphaAttribute : 0.8,
                            SMButtonHideTitleAttribute : true,
                            SMButtonNormalImagesAttribute :["image_name1", "image_name2"] as [String]),
                            SMButtonHighlightedImagesAttribute : ["high_image_name1", "high_image_name2"] as [String])
                        ]
    */
    public var buttonAttributes: [String : AnyObject]?
    
    ///Dictionary to set tab bar attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
    - Usage:
    segmentBarAttributes = [
                                SMBackgroundColorAttribute : UIColor.greenColor(),
                            ]
    */
    public var segmentBarAttributes: [String : AnyObject]?
    
    ///Dictionary to selection bar attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
    - Usage:
    segmentBarAttributes = [
                                SMBackgroundColorAttribute : UIColor.greenColor(),
                                SMAlphaAttribute : 0.8 
                            ]
    */
    public var selectionBarAttributes: [String : AnyObject]?

    /// To set the frame of the view.
    public var viewFrame : CGRect?
    
    /// Array of tab Bar Buttons (Text need to display)
    public var titleBarDataSource: [String]?
    
    /// Delegate of viewController. Set the delegate to load the viewController at new index.
    public var delegate: SMSwipeableTabViewControllerDelegate?
    
    private var pageViewController: UIPageViewController?
    
    //Fixed
    private lazy var segmentBarView = UIScrollView()
    private lazy var selectionBar = UIView()
    
    private var buttonsFrameArray = [CGRect]()
    private var currentPageIndex = 0
    private let contentSizeOffset: CGFloat = 10.0
    private var pageScrollView: UIScrollView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if let frame = viewFrame {
            self.view.frame = frame
        }
        
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        if let startingViewController = viewControllerAtIndex(0) {
            let viewControllers = [startingViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
            
            self.pageViewController!.dataSource = self
            self.pageViewController?.delegate = self
            self.addChildViewController(self.pageViewController!)
            self.view.addSubview(self.pageViewController!.view)
            
            let pageViewRect = CGRectMake(0.0, segementBarHeight, self.view.frame.width, self.view.frame.height-segementBarHeight)
            self.pageViewController!.view.frame = pageViewRect
            
            self.pageViewController!.didMoveToParentViewController(self)
            
            // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
            self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        }
        else {
            
        }
        syncScrollView()
        setupSegmentBar()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSegmentBar() {
        segmentBarView.frame = CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.width, segementBarHeight)
        segmentBarView.scrollEnabled = true
        segmentBarView.showsHorizontalScrollIndicator = false
        segmentBarView.backgroundColor = defaultSegmentBarBgColor

        if let attributes = segmentBarAttributes {
            if let bgColor = attributes[SMBackgroundColorAttribute] as? UIColor {
                segmentBarView.backgroundColor = bgColor
            }
            
            if let bgImage = attributes[SMBackgroundImageAttribute] as? UIImage {
                segmentBarView.backgroundColor = UIColor(patternImage: bgImage)
            }
        }
       
        setupSegmentBarButtons()
        self.view.addSubview(segmentBarView)
        setupSelectionBar()
    }
    
    
    private func setupSegmentBarButtons() {
        if let buttonList = titleBarDataSource {
            for var i = 0; i < buttonList.count; i++ {
                
                let previousButtonX = i > 0 ? buttonsFrameArray[i-1].origin.x : 0.0
                let previousButtonW = i > 0 ? buttonsFrameArray[i-1].size.width : 0.0
                
                let segmentButton = UIButton(frame: CGRectMake(previousButtonX + previousButtonW + buttonPadding, 0.0, getWidthForText(buttonList[i]) + buttonPadding, segementBarHeight))
                buttonsFrameArray.append(segmentButton.frame)
                segmentButton.setTitle(buttonList[i], forState: .Normal)
                segmentButton.tag = i
                segmentButton.addTarget(self, action: "didSegmentButtonTap:", forControlEvents: .TouchUpInside)
                
                if let attributes = buttonAttributes {
                    if let bgColor = attributes[SMBackgroundColorAttribute] as? UIColor {
                        segmentButton.backgroundColor = bgColor
                    }
                    
                    if let bgImage = attributes[SMBackgroundImageAttribute] as? UIImage {
                        segmentButton.setBackgroundImage(bgImage, forState: .Normal)
                    }
                    
                    if let normalImages = attributes[SMButtonNormalImagesAttribute] as? [String] {
                        segmentButton.setImage(UIImage(named: normalImages[i]), forState: .Normal)
                    }
                    
                    if let highlightedImages = attributes[SMButtonHighlightedImagesAttribute] as? [String] {
                        segmentButton.setImage(UIImage(named: highlightedImages[i]), forState: .Selected)
                    }
                    
                    if let hideTitle = attributes[SMButtonHideTitleAttribute] as? Bool where hideTitle == true{
                        segmentButton.titleLabel?.hidden = true
                        segmentButton.setTitle("", forState: .Normal)
                    }
                    else{
                        segmentButton.titleLabel?.hidden = false
                    }
                    
                    if let font = attributes[SMFontAttribute] as? UIFont {
                        segmentButton.titleLabel?.font = font
                    }
                    
                    if let foregroundColor = attributes[SMForegroundColorAttribute] as? UIColor {
                        segmentButton.setTitleColor(foregroundColor, forState: .Normal)
                    }
                    
                    if let alpha = attributes[SMAlphaAttribute] as? CGFloat {
                        segmentButton.alpha = alpha
                    }
                }
                
                segmentBarView.addSubview(segmentButton)
                
                if i == buttonList.count-1 {
                    segmentBarView.contentSize = CGSize(width:buttonsFrameArray[i].origin.x + buttonsFrameArray[i].size.width + contentSizeOffset, height: segementBarHeight)
                }
            }
        }
    }
    
    private func setupSelectionBar() {
        setupSelectionBarFrame(0)
        
        selectionBar.backgroundColor = defaultSelectionBarBgColor
        if let attributes = selectionBarAttributes {
            if let bgColor = attributes[SMBackgroundColorAttribute] as? UIColor {
                selectionBar.backgroundColor = bgColor
            }
            else {
                selectionBar.backgroundColor = defaultSelectionBarBgColor
            }
            
            if let bgImage = attributes[SMBackgroundImageAttribute] as? UIImage {
                segmentBarView.backgroundColor = UIColor(patternImage: bgImage)
            }
            
            if let alpha = attributes[SMAlphaAttribute] as? CGFloat {
                selectionBar.alpha = alpha
            }
        }
        
        segmentBarView.addSubview(selectionBar)
    }
    
    private func setupSelectionBarFrame(index: Int) {
        if buttonsFrameArray.count > 0 {
            let previousButtonX = index > 0 ? buttonsFrameArray[index-1].origin.x : 0.0
            let previousButtonW = index > 0 ? buttonsFrameArray[index-1].size.width : 0.0
            
            selectionBar.frame = CGRectMake(previousButtonX + previousButtonW + buttonPadding, segementBarHeight - selectionBarHeight, buttonsFrameArray[index].size.width, selectionBarHeight)
        }
    }
    
    private func getWidthForText(text: String) -> CGFloat {
        return buttonWidth ?? ceil((text as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17.0)]).width)
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController? {
        if titleBarDataSource?.count == 0 || index >= titleBarDataSource?.count {
            return nil
        }
        let viewController = delegate?.didLoadViewControllerAtIndex(index)
        viewController?.view.tag = index
        return viewController
    }
    
    private func syncScrollView() {
        for view: UIView in (pageViewController?.view.subviews)!
        {
            if view is UIScrollView {
                pageScrollView = view as? UIScrollView
                pageScrollView?.delegate = self
            }
        }
    }
    
    //MARK: Page View Controller Data Source
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index--
        return viewControllerAtIndex(index)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == titleBarDataSource?.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let lastVC = pageViewController.viewControllers?.last {
                currentPageIndex = lastVC.view.tag
            }
            setupSelectionBarFrame(currentPageIndex)
            segmentBarView.scrollRectToVisible(CGRectMake(buttonsFrameArray[currentPageIndex].origin.x, 0.0,  buttonsFrameArray[currentPageIndex].size.width, 44.0), animated: true)
        }
    }
    
    //MARK : Segment Button Action
    func didSegmentButtonTap(sender: UIButton) {
        let tempIndex = currentPageIndex
        if sender.tag == tempIndex { return }
        let scrollDirection: UIPageViewControllerNavigationDirection = sender.tag > tempIndex ? .Forward : .Reverse
        pageViewController?.setViewControllers([viewControllerAtIndex(sender.tag)!], direction: scrollDirection, animated: true, completion: { (complete) -> Void in
            if complete {
                self.currentPageIndex = sender.tag
                self.segmentBarView.scrollRectToVisible(CGRectMake(self.buttonsFrameArray[self.currentPageIndex].origin.x, 0.0,  self.buttonsFrameArray[self.currentPageIndex].size.width, self.segementBarHeight), animated: true)
            }
        })
    }
    
    //MARK : ScrollView Delegate Methods
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let xFromCenter:CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor = buttonsFrameArray[currentPageIndex].origin.x;
        selectionBar.frame = CGRectMake(xCoor-xFromCenter/kSelectionBarSwipeConstant, selectionBar.frame.origin.y, buttonsFrameArray[currentPageIndex].size.width, selectionBar.frame.size.height)
    }
}
