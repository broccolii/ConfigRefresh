//
//  ViewController.swift
//  ConfigRefresh
//
//  Created by Broccoli on 15/8/14.
//  Copyright (c) 2015年 brocccoli. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, ConfigRefreshDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.tableView.configRefreshDelegate = self
        self.tableView.headerRefresh = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func headerRefresh(view: UIView) {
        println("我被刷新了")
    }
    
    func footerRefresh(view: UIView) {
        
    }
}

private let CellID = "MyCell"
extension ViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: CellID)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}