//
//  UIScrollView_extension.swift
//  ConfigRefresh
//
//  Created by Broccoli on 15/8/14.
//  Copyright (c) 2015年 brocccoli. All rights reserved.
//

import UIKit

var tHeaderRefresh: Void?
var tFooterRefresh: Void?

var tConfigRefreshDelegate: Void?

extension UIScrollView {
    
    // 下拉刷新 代理
    var configRefreshDelegate: HeaderRefreshDelegate {
        set {
            objc_setAssociatedObject(self, &tConfigRefreshDelegate, newValue as! UIViewController, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
        get {
            return objc_getAssociatedObject(self, &tConfigRefreshDelegate) as! HeaderRefreshDelegate
        }
    }
    
    
    // 下拉刷新 bool
    var headerRefresh: Bool {
        set {
            objc_setAssociatedObject(self, &tHeaderRefresh, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            if newValue == true {
                let header = MJRefreshNormalHeader { () -> Void in
                    self.configRefreshDelegate.headerRefresh!(self)
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
    
    // 下拉刷新 bool
    var footerRefresh: Bool {
        set {
            objc_setAssociatedObject(self, &tFooterRefresh, newValue, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
            if newValue == true {
                let footer = MJRefreshAutoNormalFooter { () -> Void in
                    self.configRefreshDelegate.footerRefresh!(self)
                }
                self.footer = footer
            }
        }
        get {
            return objc_getAssociatedObject(self, &tHeaderRefresh) as! Bool
        }
    }
    
}

@objc protocol HeaderRefreshDelegate {
    optional func headerRefresh(view: UIView)
    optional func footerRefresh(view: UIView)
}
