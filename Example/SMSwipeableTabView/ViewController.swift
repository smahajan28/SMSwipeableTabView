//
//  ViewController.swift
//  SMSwipeableTabView
//
//  Created by Sahil Mahajan on 12/23/2015.
//  Copyright (c) 2015 Sahil Mahajan. All rights reserved.
//

import UIKit
import SMSwipeableTabView

class ViewController: UIViewController, SMSwipeableTabViewControllerDelegate {
    
    let customize = false
    let showImageOnButton = true
    var viewControllerDataSourceCollection = [["Delhi", "Gurgaon", "Noida"], ["Mumbai", "Bandra", "Andheri", "Dadar"], ["Banglore", "Kormangala", "Marathalli"], ["Jalandhar", "Ludhiana", "Chandigarh", "Patiala", "Rajpura"], ["Shri GangaNagar", "Jodhpur", "Jaipur", "Kota", "Jaisalmer"]]
    
    let titleBarDataSource = ["Delhi NCR", "Maharashtra", "Karnataka", "Punjab", "Rajasthan"]
    
    let swipeableView = SMSwipeableTabViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        swipeableView.titleBarDataSource = titleBarDataSource
        swipeableView.delegate = self
        swipeableView.viewFrame = CGRectMake(0.0, 64.0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-64.0)

        
        if customize {
            swipeableView.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.whiteColor()]
            swipeableView.selectionBarAttributes = [
                SMBackgroundColorAttribute : UIColor.blackColor(),
                SMAlphaAttribute : 0.8
            ]
            if (!showImageOnButton) {
                swipeableView.buttonAttributes = [
                    SMBackgroundColorAttribute : UIColor.clearColor(),
                    SMAlphaAttribute : 0.8,
                    SMFontAttribute : UIFont(name: "HelveticaNeue-Medium", size: 13.0)!,
                    SMForegroundColorAttribute : UIColor.greenColor()
                ]
                swipeableView.selectionBarHeight = 3.0 //For thin line
                swipeableView.segementBarHeight = 50.0 //Default is 44.0
                swipeableView.buttonPadding = 10.0 //Default is 8.0
                swipeableView.buttonWidth = 80.0
            }
            else {
                swipeableView.buttonAttributes = [
                    SMBackgroundColorAttribute : UIColor.redColor(),
                    SMAlphaAttribute : 0.8,
                    SMButtonHideTitleAttribute : true,
                    SMButtonNormalImagesAttribute : ["ic_call_made", "ic_call_missed", "ic_call_received", "ic_chat" , "ic_contacts"] as [String],
                    SMButtonHighlightedImagesAttribute : ["ic_call_made", "ic_call_missed", "ic_call_received", "ic_chat" , "ic_contacts"] as [String]
                ]
                swipeableView.selectionBarHeight = 3.0 //For thin line
                swipeableView.segementBarHeight = 40.0 //Default is 44.0
                swipeableView.buttonPadding = 10.0 //Default is 8.0
                swipeableView.buttonWidth = 50.0
            }
        }
        
        self.addChildViewController(swipeableView)
        self.view.addSubview(swipeableView.view)
        swipeableView.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: SMSwipeableTabViewControllerDelegate CallBack
    
    func didLoadViewControllerAtIndex(index: Int) -> UIViewController {
        let listVC = SMSimpleListViewController()
        listVC.dataSource = viewControllerDataSourceCollection[index]
        return listVC
    }
}

