//
//  TFAssetModel.swift
//  LGChatViewController
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import Foundation
import Photos

class TFAssetModel {
    var select: Bool
    var asset: PHAsset
    
    init(asset: PHAsset, select: Bool) {
        self.asset = asset
        self.select = select
    }
    
    func setSelect(isSelect: Bool) {
        self.select = isSelect
    }
}