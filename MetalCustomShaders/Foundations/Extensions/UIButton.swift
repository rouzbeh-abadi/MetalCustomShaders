//
//  UIButton.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import UIKit

extension UIButton {
    
    public convenience init(image: UIImage) {
        self.init()
        setImage(image, for: .normal)
    }
    
    public convenience init(title: String, titleColor: UIColor? = nil, backgroundColor: UIColor? = nil) {
        self.init()
        self.title = title
        if let value = titleColor {
            self.titleColor = value
        }
        if let value = backgroundColor {
            self.backgroundColor = value
        }
    }
    
    public var title: String? {
        get {
            return title(for: .normal)
        } set {
            setTitle(newValue, for: .normal)
        }
    }
    
    public var attributedTitle: NSAttributedString? {
        get {
            return attributedTitle(for: .normal)
        } set {
            setAttributedTitle(newValue, for: .normal)
        }
    }
    
    public var image: UIImage? {
        get {
            return image(for: .normal)
        } set {
            setImage(newValue, for: .normal)
        }
    }
    
    public var titleColor: UIColor? {
        get {
            return titleColor(for: .normal)
        } set {
            setTitleColor(newValue, for: .normal)
        }
    }
    
    public func setBackgroundImages(_ images: [(UIControl.State, UIImage?)]) {
        for (state, value) in images {
            setBackgroundImage(value, for: state)
        }
    }
    
    public func setTitles(_ titles: [(UIControl.State, String?)]) {
        for (state, value) in titles {
            setTitle(value, for: state)
        }
    }
    
    public func setTitle(_ title: String?, for states: UIControl.State...) {
        for state in states {
            setTitle(title, for: state)
        }
    }
    
    public func setTitleColor(_ color: UIColor?, for states: UIControl.State...) {
        for state in states {
            setTitleColor(color, for: state)
        }
    }
}
