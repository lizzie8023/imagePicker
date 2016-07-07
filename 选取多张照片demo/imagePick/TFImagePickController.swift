//
//  TFImagePickController.swift
//  LGChatViewController
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import UIKit
import Photos


protocol TFImagePickControllerDelegate: NSObjectProtocol {
     func customImagePickerController(picker: TFImagePickController?, didFinishPickingImages selectedAssetsArray: [PHAsset])
     func customImagePickerControllerCanceled(picker: TFImagePickController?)
}

class TFImagePickController: UITableViewController {

    weak var delegate: TFImagePickControllerDelegate?
    var viewModel: TFRootViewModel?
    var selectedAssetsArray: [PHAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TFRootViewModel()
        
        self.title = "选择相册"
        
        // hidden no used cell
        tableView.tableFooterView = UIView(frame: CGRectZero)
        weak var weakSelf = self
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) -> Void  in
            if authorizationStatus == .Authorized {
                weakSelf?.viewModel?.getCollectionList()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf?.tableView.reloadData()
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let item = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: #selector(TFAssetViewController.dismissView))
        self.navigationItem.rightBarButtonItem = item
    }
    
    func dismissView() {
        
        weak var weakSelf = self
        
        delegate?.customImagePickerControllerCanceled(weakSelf)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        super.dismissViewControllerAnimated(flag, completion: completion)
        
        weak var weakSelf = self
        
        delegate?.customImagePickerController(weakSelf, didFinishPickingImages: selectedAssetsArray)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.viewModel?.collections.value.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ImagePickreuseIdentifier")
        weak var weakSelf = self
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "ImagePickreuseIdentifier")
            cell?.imageView?.contentMode = .ScaleToFill
            cell?.accessoryType = .DisclosureIndicator
        }
        let collection = viewModel?.collections.value[indexPath.row]
        PHImageManager.defaultManager().requestImageForAsset(collection?.fetchResult.lastObject as! PHAsset, targetSize: CGSizeMake(50, 60), contentMode: .AspectFit, options: nil) { (image, _: [NSObject : AnyObject]?) -> Void in
            if image == nil {
                return
            }
            cell?.imageView?.image = image
            weakSelf?.tableView.reloadData()
        }

        cell?.textLabel?.text = collection?.title
        cell?.detailTextLabel?.text = String("\(collection!.count)")
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let fetchReslut = viewModel?.collections.value[indexPath.row]
        let gridCtrl = TFAssetGridViewController()
        gridCtrl.title = "选择照片"
        gridCtrl.assetsFetchResults = fetchReslut?.fetchResult
        gridCtrl.selectedAssetsArray = selectedAssetsArray
        gridCtrl.title = fetchReslut?.title
        self.navigationController?.pushViewController(gridCtrl, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row >= viewModel?.collections.value.count {
            return 100
        } else {
            return CGFloat(75)
        }
    }
}
