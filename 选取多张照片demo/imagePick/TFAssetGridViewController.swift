//
//  TFAssetGridViewController.swift
//  LGChatViewController
//
//  Created by jamy on 10/22/15.
//  Copyright © 2015 jamy. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "girdCell"
private let itemMargin: CGFloat = 5
private let durationTime = 0.3
private let itemSize: CGFloat = 80

class TFAssetGridViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {
    
    let presentController = TFPresentAnimationController()
    let dismissController = TFDismissAnimationController()
    
    var assetsFetchResults: PHFetchResult! {
        willSet {
            for i in 0...newValue.count - 1 {
                let asset = newValue[i] as! PHAsset
                let assetModel = TFAssetModel(asset: asset, select: false)
                self.assetModels.append(assetModel)
            }
        }
    }
    
    var toolBar: TFAssetToolView!
    var assetViewCtrl: TFAssetViewController?
    var assetModels = [TFAssetModel]()
    var previousPreRect: CGRect!
    var assetsArray: [PHAsset] = []
    var selectedAssetsArray: [PHAsset] = []
    
    lazy var imageManager: PHCachingImageManager = {
        return PHCachingImageManager()
    }()
    
    
    init() {
        let layout = UICollectionViewFlowLayout()
        let WH = (SCREENW - 50) / 4
        layout.itemSize = CGSizeMake(WH, WH)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        super.init(collectionViewLayout: layout)
        self.collectionView?.collectionViewLayout = layout
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.backgroundColor = UIColor.whiteColor()
        // Register cell classes
        self.collectionView!.registerClass(TFAssertGridViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        previousPreRect = CGRectZero
        toolBar = TFAssetToolView(rightSelector: #selector(TFAssetGridViewController.send), parent: self)
        toolBar.frame = CGRectMake(0, view.bounds.height - 50, view.bounds.width, 50)
        view.addSubview(toolBar)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        toolBar.selectCount = 0
        
        for assetModel in assetModels {
            if assetModel.select {
                toolBar.addSelectCount = 1
            }
        }
        collectionView?.reloadData()
    }
    
    func preView() {
        
        weak var weakSelf = self
        
        let assetCtrl = TFAssetViewController()
        assetCtrl.assetModels = assetModels
        assetCtrl.block = ({array in
            weakSelf?.selectedAssetsArray = array
            weakSelf?.send()
        })
        self.navigationController?.pushViewController(assetCtrl, animated: true)
    }
    
    func send() {
        navigationController?.viewControllers[0].dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.selectedIndexPath = assetViewCtrl!.currentIndex
        return dismissController
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentController
    }
}

extension TFAssetGridViewController {
    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return assetModels.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TFAssertGridViewCell
        let asset = assetModels[indexPath.row].asset
        cell.assetModel = assetModels[indexPath.row]
        cell.assetIdentifier = asset.localIdentifier
        
        cell.selectIndicator.tag = indexPath.row
        if assetModels[indexPath.row].select {
            cell.buttonSelect = true
        } else {
            cell.buttonSelect = false
        }
        cell.selectIndicator.addTarget(self, action: #selector(TFAssetGridViewController.selectButton(_:)), forControlEvents: .TouchUpInside)
        
        let scale = UIScreen.mainScreen().scale
        imageManager.requestImageForAsset(asset, targetSize: CGSizeMake(itemSize * scale, itemSize * scale), contentMode: .AspectFill, options: nil) { (image, _:[NSObject : AnyObject]?) -> Void in
            if cell.assetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        weak var weakSelf = self
        
        let assetCtrl = TFAssetViewController()
        self.selectedIndexPath = indexPath
        assetCtrl.assetModels = assetModels
        assetCtrl.selectedAssetsArray = selectedAssetsArray
        assetCtrl.selectIndex = indexPath.row
        assetCtrl.block = ({array in
            weakSelf?.selectedAssetsArray = array
            weakSelf?.send()
        })
        
        self.assetViewCtrl = assetCtrl
        let nav = UINavigationController(rootViewController: assetCtrl)
        nav.transitioningDelegate = self
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: cell button selector
    
    func selectButton(button: UIButton) {
        let assetModel = assetModels[button.tag]
        let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as! TFAssertGridViewCell
        if button.selected == false {
            assetModel.setSelect(true)
            toolBar?.addSelectCount = 1
            button.selected = true
//            button.addAnimation(durationTime)
            self.selectedAssetsArray.append(cell.assetModel.asset)
            
            button.setImage(UIImage(named: "CellBlueSelected"), forState: .Normal)
        } else {
            button.selected = false
            assetModel.setSelect(false)
            toolBar?.addSelectCount = -1
            if self.selectedAssetsArray.contains(cell.assetModel.asset) {
                let index = selectedAssetsArray.indexOf(cell.assetModel.asset)
                selectedAssetsArray.removeAtIndex(index!)
            }
            button.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
        }
    }
    
    // MARK: update chache asset
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        updateAssetChache()
    }
    
    func updateAssetChache() {
        let isViewVisible = self.isViewLoaded() && self.view.window != nil
        if !isViewVisible {
            return
        }
        
        var preRect = (self.collectionView?.bounds)!
        preRect = CGRectInset(preRect, 0, -0.5 * CGRectGetHeight(preRect))
        
        let delta = abs(preRect.midY - previousPreRect.midY)
        if delta > (collectionView?.bounds.height)! / 3 {
            var addIndexPaths = [NSIndexPath]()
            var remoeIndexPaths = [NSIndexPath]()
            
            differentBetweenRect(previousPreRect, newRect: preRect, removeHandler: { (removeRect) -> Void in
                remoeIndexPaths.appendContentsOf(self.indexPathInRect(removeRect))
                }, addHandler: { (addRect) -> Void in
                    addIndexPaths.appendContentsOf(self.indexPathInRect(addRect))
            })
            
            imageManager.startCachingImagesForAssets(assetAtIndexPath(addIndexPaths), targetSize: CGSizeMake(itemSize, itemSize), contentMode: .AspectFill, options: nil)
            imageManager.stopCachingImagesForAssets(assetAtIndexPath(remoeIndexPaths), targetSize: CGSizeMake(itemSize, itemSize), contentMode: .AspectFill, options: nil)
        }
    }
    
    func assetAtIndexPath(indexPaths: [NSIndexPath]) -> [PHAsset] {
        if indexPaths.count == 0 {
            return []
        }
        var assets = [PHAsset]()
        for indexPath in indexPaths {
            assets.append(assetsFetchResults[indexPath.row] as! PHAsset)
        }
        
        return assets
    }
    
    func indexPathInRect(rect: CGRect) -> [NSIndexPath]{
        let allAttributes = collectionView?.collectionViewLayout.layoutAttributesForElementsInRect(rect)
        if allAttributes?.count == 0 {
            return []
        }
        var indexPaths = [NSIndexPath]()
        for layoutAttribute in allAttributes! {
            indexPaths.append(layoutAttribute.indexPath)
        }
        
        return indexPaths
    }
    
    func differentBetweenRect(oldRect: CGRect, newRect: CGRect, removeHandler: (CGRect)->Void, addHandler:(CGRect)->Void) {
        if CGRectIntersectsRect(newRect, oldRect) {
            let oldMaxY = CGRectGetMaxY(oldRect)
            let oldMinY = CGRectGetMinY(oldRect)
            let newMaxY = CGRectGetMaxY(newRect)
            let newMinY = CGRectGetMinY(newRect)
            
//            if newMaxY > oldMaxY {
//                let rectToAdd = CGRectMake(newRect.x, oldMaxY, newRect.width, newMaxY - oldMaxY)
//                addHandler(rectToAdd)
//            }
//            
//            if oldMinY > newMinY {
//                let rectToAdd = CGRectMake(newRect.x, newMinY, newRect.width, oldMinY - newMinY)
//                addHandler(rectToAdd)
//            }
//            
//            if newMaxY < oldMaxY {
//                let rectToMove = CGRectMake(newRect.x, newMaxY, newRect.width, oldMaxY - newMaxY)
//                removeHandler(rectToMove)
//            }
//            
//            if oldMinY < newMinY {
//                let rectToMove = CGRectMake(newRect.x, oldMinY, newRect.width, newMinY - oldMinY)
//                removeHandler(rectToMove)
//            }
        } else {
            addHandler(newRect)
            removeHandler(oldRect)
        }
    }
}

