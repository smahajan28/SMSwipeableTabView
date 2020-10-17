//
//  SMSwipeableTabViewController.swift
//  SMSwipeableTabView
//
//  Created by Sahil Mahajan on 21/12/15.
//  Copyright © 2015 Sahil Mahajan. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}



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

/**
 Take UIColor as value. Set color of Tab button titleLabel Font when it is unselected or out of focus.
 */
public let SMUnselectedColorAttribute = "kUnselectedColorAttribute"

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
public var kSelectionBarSwipeConstant: CGFloat = 4.5

public protocol SMSwipeableTabViewControllerDelegate {
    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController
}

open class SMSwipeableTabViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    /// To set the height of segment bar(Top swipable tab bar).
    open var segementBarHeight: CGFloat = 44.0
    
    /// To set the margin beteen the buttons or tabs in the scrollable tab bar
    open var buttonPadding: CGFloat = 8.0
    
    /// To set the fixed width of the button/tab in the tab bar
    open var buttonWidth: CGFloat?
    
    /** To set the height of the selection bar
     Selection bar can be seen under the tab
     */
    open var selectionBarHeight: CGFloat = 4.0
    
    /** To set the background color of the tab bar.
     Default color is blue color. You can change the color as per your need.
     */
    public let defaultSegmentBarBgColor = UIColor.blue
    
    /** To set the background color of the selection bar.
     Default color is red color. You can change the color as per your need.
     */
    public let defaultSelectionBarBgColor = UIColor.red
    
    /** To set the background color of the selection bar.
     Default color is red color. You can change the color as per your need.
     */
    public let defaultSelectedButtonForegroundColor = UIColor.white
    
    /** To set the background color of the selection bar.
     Default color is red color. You can change the color as per your need.
     */
    public let defaultUnSelectedButtonForegroundColor = UIColor.gray
    
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
    open var buttonAttributes: [String : AnyObject]?
    
    ///Dictionary to set tab bar attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
     - Usage:
     segmentBarAttributes = [
     SMBackgroundColorAttribute : UIColor.greenColor(),
     ]
     */
    open var segmentBarAttributes: [String : AnyObject]?
    
    ///Dictionary to selection bar attributes. User can change the titleFont, titleFontColor, Normal Image, Selected Image etc.
    /**
     - Usage:
     segmentBarAttributes = [
     SMBackgroundColorAttribute : UIColor.greenColor(),
     SMAlphaAttribute : 0.8
     ]
     */
    open var selectionBarAttributes: [String : AnyObject]?
    
    /// To set the frame of the view.
    open var viewFrame : CGRect?
    
    /// Array of tab Bar Buttons (Text need to display)
    open var titleBarDataSource: [String]?
    
    /// Delegate of viewController. Set the delegate to load the viewController at new index.
    open var delegate: SMSwipeableTabViewControllerDelegate?
    
    fileprivate var pageViewController: UIPageViewController?
    
    //Fixed
    fileprivate var segmentBarView = UIScrollView()
    fileprivate lazy var selectionBar = UIView()
    
    fileprivate var buttonsFrameArray = [CGRect]()
    open var currentPageIndex = 0
    fileprivate let contentSizeOffset: CGFloat = 10.0
    fileprivate var pageScrollView: UIScrollView?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if let frame = viewFrame {
            self.view.frame = frame
        }
        
        segmentBarView.layer.shadowColor = UIColor.gray.cgColor
        segmentBarView.layer.masksToBounds = false
        segmentBarView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        segmentBarView.layer.shadowRadius = 3.0
        segmentBarView.layer.shadowOpacity = 0.5
        
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pageViewController?.automaticallyAdjustsScrollViewInsets = true
        
        if let startingViewController = viewControllerAtIndex(0) {
            let viewControllers = [startingViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
            
            self.pageViewController!.dataSource = self
            self.pageViewController?.delegate = self
            
            if let startingViewController = viewControllerAtIndex(currentPageIndex) {
                let viewControllers = [startingViewController]
                self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
            }
            
            self.addChild(self.pageViewController!)
            self.view.addSubview(self.pageViewController!.view)
            
            let pageViewRect = CGRect(x: 0.0, y: segementBarHeight, width: self.view.frame.width, height: self.view.frame.height-segementBarHeight)
            self.pageViewController!.view.frame = pageViewRect
            
            self.pageViewController!.didMove(toParent: self)
            
            // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
            self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncScrollView()
        setupSegmentBar()
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    fileprivate func setupSegmentBar() {
        if self.view.subviews.contains(segmentBarView) {
            segmentBarView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
            segmentBarView.layer.removeFromSuperlayer()
            segmentBarView.removeFromSuperview()
        }
        
        segmentBarView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: segementBarHeight)
        segmentBarView.isScrollEnabled = true
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
    
    
    fileprivate func setupSegmentBarButtons() {
        if let buttonList = titleBarDataSource {
            buttonsFrameArray.removeAll()
            for i in 0 ..< buttonList.count {
                
                let previousButtonX = i > 0 ? buttonsFrameArray[i-1].origin.x : 0.0
                let previousButtonW = i > 0 ? buttonsFrameArray[i-1].size.width : 0.0
                
                let segmentButton = UIButton(frame: CGRect(x: previousButtonX + previousButtonW + buttonPadding, y: 0.0, width: getWidthForText(buttonList[i]) + buttonPadding, height: segementBarHeight))
                buttonsFrameArray.append(segmentButton.frame)
                segmentButton.setTitle(buttonList[i], for: UIControl.State())
                segmentButton.tag = i
                segmentButton.addTarget(self, action: #selector(SMSwipeableTabViewController.didSegmentButtonTap(_:)), for: .touchUpInside)
                
                if let attributes = buttonAttributes {
                    if let bgColor = attributes[SMBackgroundColorAttribute] as? UIColor {
                        segmentButton.backgroundColor = bgColor
                    }
                    
                    if let bgImage = attributes[SMBackgroundImageAttribute] as? UIImage {
                        segmentButton.setBackgroundImage(bgImage, for: UIControl.State())
                    }
                    
                    if let normalImages = attributes[SMButtonNormalImagesAttribute] as? [String] {
                        segmentButton.setImage(UIImage(named: normalImages[i]), for: UIControl.State())
                    }
                    
                    if let highlightedImages = attributes[SMButtonHighlightedImagesAttribute] as? [String] {
                        segmentButton.setImage(UIImage(named: highlightedImages[i]), for: .selected)
                    }
                    
                    if let hideTitle = attributes[SMButtonHideTitleAttribute] as? Bool, hideTitle == true{
                        segmentButton.titleLabel?.isHidden = true
                        segmentButton.setTitle("", for: UIControl.State())
                    }
                    else{
                        segmentButton.titleLabel?.isHidden = false
                    }
                    
                    if let font = attributes[SMFontAttribute] as? UIFont {
                        segmentButton.titleLabel?.font = font
                    }
                    
                    if let foregroundColor = attributes[SMForegroundColorAttribute] as? UIColor, currentPageIndex == i{
                        segmentButton.setTitleColor(foregroundColor, for: UIControl.State())
                    }
                    else if let unSelectedForegroundColor = attributes[SMUnselectedColorAttribute] as? UIColor, currentPageIndex != i{
                        segmentButton.setTitleColor(unSelectedForegroundColor, for: UIControl.State())
                    }
                    else {
                        segmentButton.setTitleColor(defaultUnSelectedButtonForegroundColor, for: UIControl.State())
                    }
                    
                    if let alpha = attributes[SMAlphaAttribute] as? CGFloat {
                        segmentButton.alpha = alpha
                    }
                }
                else {
                    segmentButton.setTitleColor(currentPageIndex == i ? defaultSelectedButtonForegroundColor : defaultUnSelectedButtonForegroundColor , for: UIControl.State())
                }
                
                segmentBarView.addSubview(segmentButton)
                
                if i == buttonList.count-1 {
                    segmentBarView.contentSize = CGSize(width:buttonsFrameArray[i].origin.x + buttonsFrameArray[i].size.width + contentSizeOffset, height: segementBarHeight)
                }
            }
        }
    }
    
    fileprivate func setupSelectionBar() {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.setupSelectionBarFrame(self.currentPageIndex)
        }
        
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
    
    fileprivate func setupSelectionBarFrame(_ index: Int) {
        if buttonsFrameArray.count > 0 {
            let previousButtonX = index > 0 ? buttonsFrameArray[index-1].origin.x : 0.0
            let previousButtonW = index > 0 ? buttonsFrameArray[index-1].size.width : 0.0
            
            selectionBar.frame = CGRect(x: previousButtonX + previousButtonW + buttonPadding, y: segementBarHeight - selectionBarHeight, width: buttonsFrameArray[index].size.width, height: selectionBarHeight)
        }
    }
    
    fileprivate func getWidthForText(_ text: String) -> CGFloat {
        return buttonWidth ?? ceil((text as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]).width)
    }
    
    fileprivate func updateButtonColorOnSelection() {
        for button in segmentBarView.subviews {
            if button is UIButton{
                if button.tag == currentPageIndex {
                    if let attributes = buttonAttributes, let foregroundColor = attributes[SMForegroundColorAttribute] as? UIColor{
                        (button as! UIButton).setTitleColor(foregroundColor, for: UIControl.State())
                    }
                    else {
                        (button as! UIButton).setTitleColor(defaultSelectedButtonForegroundColor, for: UIControl.State())
                    }
                }
                else {
                    if let attributes = buttonAttributes, let unselectedForegroundColor = attributes[SMUnselectedColorAttribute] as? UIColor{
                        (button as! UIButton).setTitleColor(unselectedForegroundColor, for: UIControl.State())
                    }
                    else {
                        (button as! UIButton).setTitleColor(defaultUnSelectedButtonForegroundColor, for: UIControl.State())
                    }
                }
            }
        }
    }
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController? {
        if titleBarDataSource?.count == 0 || index >= titleBarDataSource?.count {
            return nil
        }
        let viewController = delegate?.didLoadViewControllerAtIndex(index)
        viewController?.view.tag = index
        return viewController
    }
    
    fileprivate func syncScrollView() {
        for view: UIView in (pageViewController?.view.subviews)!
        {
            if view is UIScrollView {
                pageScrollView = view as? UIScrollView
                pageScrollView?.delegate = self
            }
        }
    }
    
    //MARK: Page View Controller Data Source
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        return viewControllerAtIndex(index)
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == titleBarDataSource?.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let lastVC = pageViewController.viewControllers?.last {
                currentPageIndex = lastVC.view.tag
            }
            UIView.animate(withDuration: 0.1) { [unowned self] in
                self.setupSelectionBarFrame(self.currentPageIndex)
                self.updateButtonColorOnSelection()
                self.segmentBarView.scrollRectToVisible(CGRect(x: self.buttonsFrameArray[self.currentPageIndex].origin.x, y: 0.0,  width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: 44.0), animated: true)
            }
        }
    }
    
    //MARK : Segment Button Action
    @objc func didSegmentButtonTap(_ sender: UIButton) {
        let tempIndex = currentPageIndex
        if sender.tag == tempIndex { return }
        let scrollDirection: UIPageViewController.NavigationDirection = sender.tag > tempIndex ? .forward : .reverse
        pageViewController?.setViewControllers([viewControllerAtIndex(sender.tag)!], direction: scrollDirection, animated: true, completion: { (complete) -> Void in
            if complete {
                self.currentPageIndex = sender.tag
                UIView.animate(withDuration: 0.05) { [unowned self] in
                    self.updateButtonColorOnSelection()
                    self.segmentBarView.scrollRectToVisible(CGRect(x: self.buttonsFrameArray[self.currentPageIndex].origin.x, y: 0.0,  width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: 44.0), animated: true)
                }
            }
        })
    }
    
    //MARK : ScrollView Delegate Methods
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xFromCenter:CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor = buttonsFrameArray[currentPageIndex].origin.x;
        UIView.animate(withDuration: 0.05) { [unowned self] in
            self.selectionBar.frame = CGRect(x: xCoor-xFromCenter/kSelectionBarSwipeConstant, y: self.selectionBar.frame.origin.y, width: self.buttonsFrameArray[self.currentPageIndex].size.width, height: self.selectionBar.frame.size.height)
        }
    }
}
