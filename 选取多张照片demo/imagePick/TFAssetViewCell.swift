//
//  TFAssetViewCell.swift
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import UIKit
import PhotosUI
import SnapKit

class TFAssetViewCell: UICollectionViewCell {
    
    var viewModel: TFAssetViewModel? {
        didSet {
            viewModel?.image.observe {
                [unowned self] in
                if self.imageView.hidden {
                    self.imageView.hidden = false
                }
                self.imageView.image = $0
            }
            
            viewModel?.asset.observe {
                [unowned self] in
                if $0.mediaType == .Video {
                    self.playIndicator?.hidden = false
                } else {
                    self.playIndicator?.hidden = true
                }
            }
        }
    }
    
    var imageView: UIImageView!
    var playLayer: AVPlayerLayer?
    var playIndicator: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        contentView.addSubview(imageView)
        
        playIndicator = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        playIndicator?.center = contentView.center
        playIndicator?.image = UIImage(named: "MessageVideoPlay")
        contentView.addSubview(playIndicator!)
        playIndicator?.hidden = true
        imageView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(-120)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.right.equalTo(contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopPlayer()
    }
    
    func stopPlayer() {
        if let player = self.playLayer {
            player.player?.pause()
            player.removeFromSuperlayer()
        }
        playLayer = nil
    }
}
