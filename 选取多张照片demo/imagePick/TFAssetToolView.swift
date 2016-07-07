//
//  LGAssetToolView.swift
//  LGChatViewController
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import UIKit

private let buttonWidth = 20
private let durationTime = 0.3

class TFAssetToolView: UIView {
    var preViewButton: UIButton!
    var totalButton: UIButton!
    var sendButton: UIButton!
    weak var parent: UIViewController!
    
    var selectCount = Int() {
        willSet {
            if newValue > 0 {
                
//                totalButton.addAnimation(durationTime)
                totalButton.hidden = false
                totalButton.setTitle("\(newValue)", forState: .Normal)
            } else {
                totalButton.hidden = true
            }
        }
    }
    
    var addSelectCount: Int? {
        willSet {
            selectCount += newValue!
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    convenience init(rightSelector: Selector, parent: UIViewController) {
        self.init()
        self.parent = parent
        
        totalButton = UIButton(type: .Custom)
        totalButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
//        totalButton.setBackgroundImage(UIImage.imageWithColor(UIColor.greenColor(), size: CGSizeMake(10, 10)), forState: .Normal)
        totalButton.layer.cornerRadius = CGFloat(buttonWidth / 2)
        totalButton.layer.masksToBounds = true
        totalButton.hidden = true
        
        sendButton = UIButton(type: .Custom)
        sendButton.titleLabel?.font = UIFont.systemFontOfSize(14.0)
        sendButton.setTitle("完成", forState: .Normal)
        sendButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        sendButton.addTarget(parent, action: rightSelector, forControlEvents: .TouchUpInside)
        
        backgroundColor = UIColor.blackColor()
        self.alpha = 0.7
        
        addSubview(totalButton)
        addSubview(sendButton)
        
        totalButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
//        sendButton.ff_AlignInner(type: ff_AlignType.CenterRight, referView: self, size: CGSizeMake(50, 45), offset: CGPointMake(0, 0))
        
//        totalButton.ff_AlignHorizontal(type: ff_AlignType.CenterLeft, referView: sendButton, size: CGSizeMake(20, 20))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
