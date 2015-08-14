//
//  UIScrollView_extension.swift
//  ConfigRefresh
//
//  Created by Broccoli on 15/8/14.
//  Copyright (c) 2015年 brocccoli. All rights reserved.
//

import UIKit

var tHeaderRefresh: Void?
var tConfigRefreshDelegate: Void?

extension UIScrollView {

    // 下拉刷新 代理
    var refreshDelegate: ConfigRefreshDelegate {
        set {
            objc_setAssociatedObject(self, &tConfigRefreshDelegate, newValue as! UIViewController, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
        get {
            return objc_getAssociatedObject(self, &tConfigRefreshDelegate) as! ConfigRefreshDelegate
        }
    }
    
    
    
    
    // 下拉刷新 bool
    var headerRefresh: Bool {
        set {
            objc_setAssociatedObject(self, &tHeaderRefresh, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            if newValue == true {
                let header = MJRefreshNormalHeader { () -> Void in
                    self.refreshDelegate.headerRefresh(self)
                }
                /**
                *  配置参数
                */
                header.lastUpdatedTimeLabel.hidden = true
                header.stateLabel.hidden = true
                header.beginRefreshing()
                
                self.header = header
            }
        }
        get {
            return objc_getAssociatedObject(self, &tHeaderRefresh) as! Bool
        }
        
    }

}


protocol ConfigRefreshDelegate {
    func headerRefresh(view: UIView)
    func footerRefresh(view: UIView)
}