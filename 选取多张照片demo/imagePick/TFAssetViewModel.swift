//
//  TFAssetViewModel.swift
//  LGWeChatKit
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import Foundation
import Photos

class TFAssetViewModel {
    let asset: Observable<PHAsset>
    let image: Observable<UIImage>
    
    init(assetMode: TFAssetModel) {
        asset = Observable(assetMode.asset)
        image = Observable(UIImage())
    }
    
    func getTargetSize(size: CGSize) -> CGSize {
        let scale = UIScreen.mainScreen().scale
        let targetSize = CGSizeMake(size.width * scale, size.height * scale)
        
        return targetSize
    }
    
    func updateImage(size: CGSize) {
    
        updateStaticImage(size)
    }
    
    func updateStaticImage(size: CGSize) {
        let option = PHImageRequestOptions()
        option.deliveryMode = .HighQualityFormat
        option.networkAccessAllowed = true
        option.synchronous = true
        option.resizeMode = PHImageRequestOptionsResizeMode.Fast
        
        PHImageManager.defaultManager().requestImageForAsset(asset.value, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.Default, options: option) { (image, _: [NSObject : AnyObject]?) -> Void in
            
            guard image != nil else {
                return
            }
            
            self.image.value = image!
        }
    }
}