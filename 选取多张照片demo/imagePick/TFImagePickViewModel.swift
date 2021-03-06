//
//  TFRootViewModel.swift
//  
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import Foundation
import Photos

class TFRootViewModel {
    let collections: Observable<[PHRootModel]>
    
    init() {
        collections = Observable([])
    }
    
    func getCollectionList() {
    
        let albumOptions = PHFetchOptions()
        albumOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let userAlbum = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        
        userAlbum.enumerateObjectsUsingBlock { (collection, index, stop) -> Void in
            let coll = collection as! PHAssetCollection
            let assert = PHAsset.fetchAssetsInAssetCollection(coll, options: nil)
            if assert.count > 0 {
                let model = PHRootModel(title: coll.localizedTitle!, count: assert.count, fetchResult: assert)
                self.collections.value.append(model)
            }
        }
        
        let userCollection = PHCollectionList.fetchTopLevelUserCollectionsWithOptions(nil)
        
        userCollection.enumerateObjectsUsingBlock { (list, index, stop) -> Void in
            let list = list as! PHAssetCollection
            let assert = PHAsset.fetchAssetsInAssetCollection(list, options: nil)
            if assert.count > 0 {
                let model = PHRootModel(title: list.localizedTitle!, count: assert.count, fetchResult: assert)
                self.collections.value.append(model)
            }
        }
        
    }
}
