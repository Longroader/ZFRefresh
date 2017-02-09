//
//  ViewController.swift
//  ZFRefresh
//
//  Created by fengfeng on 17/2/6.
//  Copyright © 2017年 XiaoDream. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let ID = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ZFRefresh"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: ID)
        
        // 1.创建刷新控件，添加监听
        refreshControl = ZFRefreshControl(navBar: navigationController!.navigationBar)
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
    }
    
    @objc private func loadData() {
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            /**
            2.网络请求成功或者失败后，结束刷新
            
            :param: (10) 刷新到的数据量
            */
            self.refreshControl?.zf_endRefreshing(10)
        }
    }
}

extension ViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ID, forIndexPath: indexPath)
        cell.textLabel?.text = "测试数据\(indexPath.row)"
        cell.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.9)
        return cell
    }
}