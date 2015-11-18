//
//  UIScrollView_refresh.swift
//  iDoc
//
//  Created by Broccoli on 15/9/8.
//  Copyright (c) 2015年 iue. All rights reserved.
//

import UIKit

var tHeaderRefresh: Void?
var tFooterRefresh: Void?
var tTotalPages: Void?
var tConfigRefreshDelegate: Void?
var tCurrentPage: Void?

// MARK: - 扩展UIScrollView  使 ScrollView中 TableView中的TextField和TextView 点击空白处取消键盘
extension UIScrollView {
    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for subView in self.subviews {
            
            if subView.isKindOfClass(UITextField.superclass()!) {
                subView.resignFirstResponder()
            }
            if subView.isKindOfClass(UITextView.superclass()!) {
                subView.resignFirstResponder()
            }
            
            if subView.isKindOfClass(UITableView.superclass()!){
                for tableView in subView.subviews {
                    if tableView.isKindOfClass(UITableViewCell.superclass()!){
                        for cellView in tableView.subviews {
                            for view in cellView.subviews {
                                if view is UITextView {
                                    view.resignFirstResponder()
                                }
                                if view is UITextField {
                                    view.resignFirstResponder()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UIScrollView {
    // 下拉刷新 代理
    var configRefreshDelegate: ConfigRefreshDelegate {

        set {
            objc_setAssociatedObject(self, &tConfigRefreshDelegate, newValue as! UIViewController, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            return objc_getAssociatedObject(self, &tConfigRefreshDelegate) as! ConfigRefreshDelegate
        }
    }
    
    
    // 下拉刷新 bool
    var headerRefresh: Bool {
        set {
            objc_setAssociatedObject(self, &tHeaderRefresh, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == true {
                self.footerRefresh = false
               
                self.header = AnimationRefresh(refreshingBlock: { () -> Void in
                    self.demandPage = 1
                    self.configRefreshDelegate.headerRefresh!(self)
                })
                self.header.beginRefreshing()
                self.header.automaticallyChangeAlpha = true
                
              
            } else {
                
            }
        }
        get {
            return objc_getAssociatedObject(self, &tHeaderRefresh) as! Bool
        }
    }
    
    // 上拉加载 bool
    var footerRefresh: Bool {
        set {
            objc_setAssociatedObject(self, &tFooterRefresh, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if newValue == true {

                let footer = MJRefreshAutoNormalFooter { () -> Void in
                    self.configRefreshDelegate.footerRefresh!(self)
                }
                
                self.footer = footer
            } else {
                self.footer = nil
            }
        }
        get {
            return objc_getAssociatedObject(self, &tFooterRefresh) as! Bool
        }
    }
    
    var totalPages: Int {
        set {
            objc_setAssociatedObject(self, &tTotalPages, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
             self.header.endRefreshing()
            if newValue != 0 {
                self.footerRefresh = true
                print(self.demandPage)
//                println(self.totalPages)
                if self.demandPage >= newValue {
                    self.footerRefresh = false
                }
                self.demandPage++
                self.header.endRefreshing()
            } else {
                self.footerRefresh = false
            }
        }
        get {
            if objc_getAssociatedObject(self, &tTotalPages) != nil {
                return objc_getAssociatedObject(self, &tTotalPages) as! Int
            } else {
                return 0
            }
        }
    }
    
    var demandPage: Int {
        set {
            objc_setAssociatedObject(self, &tCurrentPage, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
               return objc_getAssociatedObject(self, &tCurrentPage) as! Int
        }
    }
}

/**
*  ConfigRefreshDelegate 回调方法
*/
@objc protocol ConfigRefreshDelegate {
    optional func headerRefresh(view: UIView)
    optional func footerRefresh(view: UIView)
}