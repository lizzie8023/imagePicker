//
//  Observable.swift
//  LGChatViewController
//
//  Created by 风晓得8023 on 15/10/23.
//  Copyright © 2015年 Tuofeng. All rights reserved.
//

import Foundation


class Observable<T> {
    typealias Observer = T -> Void
    var observer: Observer?
    
    func observe(observer: Observer?) {
        self.observer = observer
        observer?(value)
    }
    
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}