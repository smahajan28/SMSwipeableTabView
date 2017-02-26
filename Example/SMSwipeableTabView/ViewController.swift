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
        swipeableView.viewFrame = CGRect(x: 0.0, y: 64.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64.0)
        kSelectionBarSwipeConstant = CGFloat(titleBarDataSource.count)

        if customize {
            swipeableView.segmentBarAttributes = [SMBackgroundColorAttribute : UIColor.white]
            swipeableView.selectionBarAttributes = [
                SMBackgroundColorAttribute : UIColor.black,
                SMAlphaAttribute : 0.8 as AnyObject
            ]
            if (!showImageOnButton) {
                swipeableView.buttonAttributes = [
                    SMBackgroundColorAttribute : UIColor.clear,
                    SMAlphaAttribute : 0.8 as AnyObject,
                    SMFontAttribute : UIFont(name: "HelveticaNeue-Medium", size: 13.0)!,
                    SMForegroundColorAttribute : UIColor.green
                ]
                swipeableView.selectionBarHeight = 3.0 //For thin line
                swipeableView.segementBarHeight = 50.0 //Default is 44.0
                swipeableView.buttonPadding = 10.0 //Default is 8.0
                swipeableView.buttonWidth = 80.0
            }
            else {
                swipeableView.buttonAttributes = [
                    SMBackgroundColorAttribute : UIColor.red,
                    SMAlphaAttribute : 0.8 as AnyObject,
                    SMButtonHideTitleAttribute : true as AnyObject,
                    SMButtonNormalImagesAttribute : ["ic_call_made", "ic_call_missed", "ic_call_received", "ic_chat" , "ic_contacts"] as [String] as AnyObject,
                    SMButtonHighlightedImagesAttribute : ["ic_call_made", "ic_call_missed", "ic_call_received", "ic_chat" , "ic_contacts"] as [String] as AnyObject
                ]
                swipeableView.selectionBarHeight = 3.0 //For thin line
                swipeableView.segementBarHeight = 40.0 //Default is 44.0
                swipeableView.buttonPadding = 10.0 //Default is 8.0
                swipeableView.buttonWidth = 50.0
            }
        }
        
        self.addChildViewController(swipeableView)
        self.view.addSubview(swipeableView.view)
        swipeableView.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: SMSwipeableTabViewController Delegate CallBack
    
    func didLoadViewControllerAtIndex(_ index: Int) -> UIViewController {
        switch index {
        case 0:
            let listVC = SMSimpleListViewController()
            listVC.dataSource = viewControllerDataSourceCollection[index] as [AnyObject]?
            return listVC
        case 1:
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.red
            return vc
        case 2:
            let listVC = SMSimpleListViewController()
            listVC.dataSource = viewControllerDataSourceCollection[index] as [AnyObject]?
            return listVC
        case 3:
            let listVC = SMSimpleListViewController()
            listVC.dataSource = viewControllerDataSourceCollection[index] as [AnyObject]?
            return listVC
        case 5:
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.brown
            return vc
        default:
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.green
            return vc
        }
    }
}

