//
//  DataViewController.swift
//  SwipableViews
//
//  Created by Sahil Mahajan on 21/12/15.
//  Copyright © 2015 Sahil Mahajan. All rights reserved.
//

import UIKit

public class SMSimpleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataSource: [AnyObject]?
    var pageIndex = 0
    var buttonDataSource: [String]?
    
    @IBOutlet var mainTableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        self.view.addSubview(mainTableView)
        mainTableView?.reloadData()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier")
        if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "CellIdentifier")
        }
        if let data = dataSource {
            cell!.textLabel?.text = data[indexPath.row] as? String
        }
        return cell!
    }
}
