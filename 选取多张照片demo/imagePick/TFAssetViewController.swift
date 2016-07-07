//
//  TFAssetViewController.swift
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import UIKit
import Photos

let SCREENW = UIScreen.mainScreen().bounds.width
let SCREENH = UIScreen.mainScreen().bounds.height

private let reuseIdentifier = "assetviewcell"
class TFAssetViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    var currentIndex: NSIndexPath!
    var selectButton: UIButton!
    var playButton: UIBarButtonItem!
    var cellSize: CGSize!
    private var toolBar: TFAssetToolView!
    
    /// 照片对象
    var assetModels = [TFAssetModel]()
    var selectedAssetsArray: [PHAsset] = []
    var selectIndex = 0
    
    var block:((array:[PHAsset])->())?
    
    lazy var imageManager: PHCachingImageManager = {
        return PHCachingImageManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        cellSize = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        collectionView.selectItemAtIndexPath(NSIndexPath(forItem: selectIndex, inSection: 0), animated: false, scrollPosition: .CenteredHorizontally)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func send() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if let block = self.block {
            block(array: selectedAssetsArray)
        }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(SCREENW, SCREENH)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.registerClass(TFAssetViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = UIColor.blackColor()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.pagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupNavgationBar()
        
        toolBar = TFAssetToolView(rightSelector: #selector(TFAssetViewController.send), parent: self)
        toolBar.frame = CGRectMake(0, view.bounds.height - 50, view.bounds.width, 50)
        view.addSubview(toolBar)
        
        for assetModel in assetModels {
            if assetModel.select {
                toolBar.addSelectCount = 1
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func setupNavgationBar() {
        let button = UIButton(type: .Custom)
        button.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
        button.frame = CGRectMake(0, 0, 30, 30)
        button.addTarget(self, action: #selector(TFAssetViewController.selectCurrentImage), forControlEvents: .TouchUpInside)
        let item = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = item
        selectButton = button
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .Done, target: self, action: #selector(TFAssetViewController.dismissView))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func selectCurrentImage() {
        
        let indexPaths = collectionView.indexPathsForVisibleItems()
        let indexpath = indexPaths.first
        let cell = collectionView.cellForItemAtIndexPath(indexpath!) as! TFAssetViewCell
        let asset = assetModels[(indexpath?.row)!]
        if asset.select {
            asset.select = false
            toolBar.addSelectCount = -1
            if selectedAssetsArray.contains(asset.asset) {
                let index = selectedAssetsArray.indexOf(asset.asset)
                selectedAssetsArray.removeAtIndex(index!)
            }
            selectButton.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
        } else {
            
            if selectedAssetsArray.count >= 7 {
            }else{
                asset.select = true
                toolBar.addSelectCount = 1
                selectedAssetsArray.append(asset.asset)
                selectButton.setImage(UIImage(named: "CellBlueSelected"), forState: .Normal)
                cell.tag = (selectedAssetsArray.count)
            }
        }
    }
    
    func dismissView() {
//        
//        if let block = self.block {
//            block(array: selectedAssetsArray)
//        }
//        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - collectionView delegate
extension TFAssetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assetModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! TFAssetViewCell
        
        let assetModel = assetModels[indexPath.row]
        let viewModel = TFAssetViewModel(assetMode: assetModel)
        viewModel.updateImage(cellSize)
        cell.viewModel = viewModel
        
        if assetModel.select {
            selectButton.setImage(UIImage(named: "CellBlueSelected"), forState: .Normal)
        } else {
            selectButton.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
        }
        currentIndex = indexPath
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        navigationController!.navigationBar.hidden = !navigationController!.navigationBar.hidden
    }
    
}

// MARK: - scrollView delegate
extension TFAssetViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = Int(collectionView.contentOffset.x / view.bounds.width + 0.5)
        
        self.title = "\(offsetX + 1)" + "/" + "\(assetModels.count)"
        if offsetX >= 0 && offsetX < assetModels.count && selectButton != nil {
            let assetModel = assetModels[offsetX]
            if assetModel.select {
                selectButton.setImage(UIImage(named: "CellBlueSelected"), forState: .Normal)
            } else {
                selectButton.setImage(UIImage(named: "CellGreySelected"), forState: .Normal)
            }
        }
    }
}



