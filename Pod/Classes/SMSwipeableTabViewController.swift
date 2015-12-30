//
//  SMSwipeableTabViewController.swift
//  SMSwipeableTabView
//
//  Created by Sahil Mahajan on 21/12/15.
//  Copyright © 2015 Sahil Mahajan. All rights reserved.
//

import UIKit

public let SMFontAttribute = "kFontAttribute" // Set UIFont insatance
public let SMForegroundColorAttribute = "kForegroundColorAttribute" // Set UIColor instance
public let SMBackgroundColorAttribute = "kBackgroundColorAttribute" // Set UIColor instance
public let SMAlphaAttribute = "kAlphaAttribute" // Set CGFloat value
public let SMBackgroundImageAttribute = "kBackgroundImageAttribute" // Set UIImage instance
public let SMButtonNormalImageAttribute = "kButtonNormalImageAttribute" // Set UIImage instance
public let SMButtonHighlightedImageAttribute = "kButtonHighlightedImageAttribute" // Set UIImage instance
public let SMButtonHideTitleAttribute = "kButtonShowTitleAttribute" // Set Bool instance

public protocol SMSwipeableTabViewControllerDelegate {
    func didLoadViewControllerAtIndex(index: Int) -> UIViewController
}

public class SMSwipeableTabViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    
    public var segementBarHeight: CGFloat = 44.0
    public var buttonPadding: CGFloat = 8.0
    public var buttonWidth: CGFloat?
    public var selectionBarHeight: CGFloat = 4.0
    private let contentSizeOffset: CGFloat = 10.0
    
    public let defaultSegmentBarBgColor = UIColor.blueColor()
    public let defaultSelectionBarBgColor = UIColor.redColor()

    public var buttonAttributes: [String : AnyObject]?
    public var segmentBarAttributes: [String : AnyObject]?
    public var selectionAttributes: [String : AnyObject]?

    public var delegate: SMSwipeableTabViewControllerDelegate?
    
    private var pageViewController: UIPageViewController?
    
    //For Top Segment Bar
    //Array of Segment Bar Buttons (Text need to display)
    public var titleBarDataSource: [String]?
    
    //Fixed
    private lazy var segmentBarView = UIScrollView()
    private lazy var selectionBar = UIView()
    
    private var buttonsFrameArray = [CGRect]()
    private var currentPageIndex = 0
    private var pageScrollView: UIScrollView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
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
                    
                    if let normalImage = attributes[SMButtonNormalImageAttribute] as? UIImage {
                        segmentButton.setImage(normalImage, forState: .Normal)
                    }
                    
                    if let highlightedImage = attributes[SMButtonHighlightedImageAttribute] as? UIImage {
                        segmentButton.setImage(highlightedImage, forState: .Selected)
                    }
                    
                    if let hideTitle = attributes[SMButtonHideTitleAttribute] as? Bool where hideTitle == true{
                        segmentButton.titleLabel?.hidden = true
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
        if let attributes = buttonAttributes {
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
    
    //MARK : Segment Button
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
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let xFromCenter:CGFloat = self.view.frame.size.width-scrollView.contentOffset.x
        let xCoor = buttonsFrameArray[currentPageIndex].origin.x;
        selectionBar.frame = CGRectMake(xCoor-xFromCenter/CGFloat(titleBarDataSource?.count ?? 0), selectionBar.frame.origin.y, buttonsFrameArray[currentPageIndex].size.width, selectionBar.frame.size.height)
//        setupSelectionBarFrame(currentPageIndex)
    }
}
