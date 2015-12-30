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
    
    var viewControllerDataSourceCollection = [["Delhi", "Gurgaon", "Noida"], ["Mumbai", "Bandra", "Andheri", "Dadar"], ["Banglore", "Kormangala", "Marathalli"], ["Jalandhar", "Ludhiana", "Chandigarh", "Patiala", "Rajpura"], ["Shri GangaNagar", "Jodhpur", "Jaipur", "Kota", "Jaisalmer"]]
    
    let titleBarDataSource = ["Delhi NCR", "Maharashtra", "Karnataka", "Punjab", "Rajasthan"]
    
    let swipeableView = SMSwipeableTabViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        swipeableView.titleBarDataSource = titleBarDataSource
        swipeableView.delegate = self
        swipeableView.view.frame = CGRectMake(0.0, 64.0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height-64.0)
        self.addChildViewController(swipeableView)
        self.view.addSubview(swipeableView.view)
        swipeableView.didMoveToParentViewController(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didLoadViewControllerAtIndex(index: Int) -> UIViewController {
        let listVC = SMSimpleListViewController()
        listVC.dataSource = viewControllerDataSourceCollection[index]
        return listVC
    }
}

