//
//  ViewController.swift
//  选取多张照片demo
//
//  Created by 风晓得8023 on 15/12/14.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//http://7xo0vr.com2.z0.glb.qiniucdn.com/258c013b-d51f-4c02-a57f-dcb69c4b8106?e=1456149799&token=YcpKvalx4EaVwmcKfl3ewdyyqVcb4D11Wt4eHXg-:vbc2OlF_U17-AiSVaMmlHoiU9QA=

import UIKit
import Photos
import SnapKit
import Kingfisher

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let test1Btn = UIButton(frame: CGRectMake(0,0,100,100))
        test1Btn.backgroundColor = randomColor()
        test1Btn.setTitle("选中多张照片", forState: UIControlState.Normal)
        test1Btn.addTarget(self, action: #selector(ViewController.chooseImage), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(test1Btn)
        
        let test2Btn = UIButton(frame: CGRectMake(100,0,100,100))
        test2Btn.backgroundColor = randomColor()
        test2Btn.setTitle("图片缓存", forState: UIControlState.Normal)
        test2Btn.addTarget(self, action: #selector(ViewController.downLoadImage), forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(test2Btn)
    }
    
    @objc private func downLoadImage() {
        
        let imageView = UIImageView()
        let myCache = ImageCache(name: "my_cache")
        
        
        KingfisherManager.sharedManager
        
        imageView.backgroundColor = randomColor()
        dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
            dispatch_after(5, dispatch_get_global_queue(0, 0), { () -> Void in
                
                imageView.kf_setImageWithURL(NSURL(string: "http://www.imtranslationweb.com/wp-content/uploads/2015/07/1421287_832851500081441_8981523569018632931_o.jpg")!,
                    placeholderImage: nil,
                    optionsInfo: [.TargetCache(myCache)])
            })
        }
        self.view.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.width.equalTo(self.view.snp_width)
            make.height.equalTo(self.view.snp_width)
        }
    }
    
    @objc private func chooseImage() {
    
        let imagePick = TFImagePickController()
//        imagePick.delegate = self
        let nav = UINavigationController(rootViewController: imagePick)
        self.presentViewController(nav, animated: true, completion: nil)
    }

    // MARK: - UIImagePick delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    /**
     选完照片后的回调
     */
    func imagePickerController(picker: TFImagePickController, didFinishPickingImages images: [UIImage]) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    }
    
    func imagePickerControllerCanceled(picker: TFImagePickController) {
        
    }
    
    
    func RGB(r r: CGFloat,g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
    
    func randomColor() -> UIColor {
        return RGB(r: CGFloat(random() % 255), g: CGFloat(random() % 255), b: CGFloat(random() % 255))
    }
}