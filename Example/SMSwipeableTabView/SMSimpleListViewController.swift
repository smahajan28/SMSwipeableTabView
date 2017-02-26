//
//  DataViewController.swift
//  SwipableViews
//
//  Created by Sahil Mahajan on 21/12/15.
//  Copyright © 2015 Sahil Mahajan. All rights reserved.
//

import UIKit

open class SMSimpleListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataSource: [AnyObject]?
    var pageIndex = 0
    var buttonDataSource: [String]?
    
    @IBOutlet var mainTableView: UITableView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        self.view.addSubview(mainTableView)
        mainTableView?.reloadData()
    }

    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellIdentifier")
        }
        if let data = dataSource {
            cell!.textLabel?.text = data[indexPath.row] as? String
        }
        return cell!
    }
}
