//
//  ZFRefreshControl.swift
//  ZFRefresh
//
//  Created by fengfeng on 16/11/6.
//  Copyright © 2016年 XiaoDream. All rights reserved.
//

import UIKit

let kHEIGHT: CGFloat = 44
let kWIDTH: CGFloat = UIScreen.mainScreen().bounds.width

class ZFRefreshControl: UIRefreshControl {

    static var dataCount = 0
    lazy var refreshView: ZFRefreshView = ZFRefreshView.zf_refreshView()
    lazy var refreshLabel: ZFRefreshLabel = ZFRefreshLabel()

    init(navBar: UINavigationBar) {
        super.init()
        
        self.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT)
        addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        
        addSubview(refreshView)
        refreshView.center.x = self.center.x
        
        navBar.insertSubview(refreshLabel, atIndex: 0)
        refreshLabel.frame = frame
    }
    
    var arrowFlag = false
    var loadingFlag = false
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if frame.origin.y >= 0 { return }
        
        if refreshing && !loadingFlag {
            loadingFlag = true
            refreshView.loadingIconAnim()
            return
        }
        
        if frame.origin.y >= -50 && arrowFlag {
            arrowFlag = false
            refreshView.arrowIconAnim(arrowFlag)
        } else if frame.origin.y <= -50 && !arrowFlag {
            arrowFlag = true
            refreshView.arrowIconAnim(arrowFlag)
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshView.endLoadingIconAnim()
        loadingFlag = false
        refreshLabel.refreshLabelAnim(ZFRefreshControl.dataCount)
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIRefreshControl {
    /// 结束刷新
    public func zf_endRefreshing(dataCount: Int) {
        ZFRefreshControl.dataCount = dataCount
        endRefreshing()
    }
}

class ZFRefreshView: UIView {
    @IBOutlet weak var loadingIcon: UIImageView!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    class func zf_refreshView() -> ZFRefreshView {
        return NSBundle.mainBundle().loadNibNamed("ZFRefreshView", owner: nil, options: nil).last as! ZFRefreshView
    }
    
    func arrowIconAnim(flag: Bool) {
        var angle = M_PI
        angle += flag ? -0.01 : 0.01
        UIView.animateWithDuration(0.5) { () -> Void in
            self.arrowIcon.transform = CGAffineTransformRotate(self.arrowIcon.transform, CGFloat(angle))
        }
    }
    
    func loadingIconAnim() {
        tipView.hidden = true
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = 1.0
        anim.toValue = 2 * M_PI
        anim.repeatCount = MAXFLOAT
        loadingIcon.layer.addAnimation(anim, forKey: nil)
    }
    
    func endLoadingIconAnim() {
        tipView.hidden = false
        loadingIcon.layer.removeAllAnimations()
    }
}

class ZFRefreshLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 245/255, green: 139/255, blue: 31/255, alpha: 0.9)
        textColor = UIColor.whiteColor()
        font = UIFont.boldSystemFontOfSize(14.0)
        textAlignment = NSTextAlignment.Center
        self.hidden = true
    }

    func refreshLabelAnim(dataCount: Int) {
        self.hidden = false
        text = (dataCount == 0) ? "暂无更新的数据" : "刷新了\(dataCount)条数据"
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.transform = CGAffineTransformMakeTranslation(0, kHEIGHT)
            }) { (_) -> Void in
                UIView.animateWithDuration(0.5, delay: 1.0, options: [], animations: { () -> Void in
                    self.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        self.hidden = true
                })
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
