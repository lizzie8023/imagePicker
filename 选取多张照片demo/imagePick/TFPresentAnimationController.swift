//
//  TFPresentAnimationController.swift
//  LGWeChatKit
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import UIKit

class TFPresentAnimationController: NSObject , UIViewControllerAnimatedTransitioning{

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromCtrl = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! UINavigationController).topViewController as! UICollectionViewController
        let toCtrl = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let containertView = transitionContext.containerView()
        let finalFrame = transitionContext.finalFrameForViewController(toCtrl!)
        let layoutAttribute = fromCtrl.collectionView?.layoutAttributesForItemAtIndexPath((fromCtrl.selectedIndexPath)!)
        let selectRect = fromCtrl.collectionView?.convertRect((layoutAttribute?.frame)!, toView: fromCtrl.collectionView?.superview)

        toView?.frame = selectRect!
        containertView?.addSubview(toView!)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 1.5, initialSpringVelocity: 0.0, options: .CurveLinear, animations: { () -> Void in
            fromView?.alpha = 0.5
            toView?.frame = finalFrame
            }) { (finish) -> Void in
               transitionContext.completeTransition(true)
                fromView?.alpha = 1
        }
    }
}
