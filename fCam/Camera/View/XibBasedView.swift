//
//  XibBasedView.swift
//  fCam
//
//  Created by Nguyễn Linh on 06/06/2024.
//

import UIKit

open class XibBasedView: UIView {
    
    open var contentView: UIView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.load()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    
    open func load() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: NSStringFromClass(type(of: self)).components(separatedBy: ".").last!, bundle: bundle)
        contentView = (nib.instantiate(withOwner: self, options: nil)[0] as! UIView)
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(contentView)
    }
}

