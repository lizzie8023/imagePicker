//
//  LGCollectionControllerExtension.swift
//  LGWeChatKit
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//


import UIKit
import ObjectiveC


private var selectedIndexPathKey: UInt8 = 101
extension UICollectionViewController {
    var selectedIndexPath: NSIndexPath?{
        get {
            return objc_getAssociatedObject(self, &selectedIndexPathKey) as? NSIndexPath
        }
        
        set {
            objc_setAssociatedObject(self, &selectedIndexPathKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}