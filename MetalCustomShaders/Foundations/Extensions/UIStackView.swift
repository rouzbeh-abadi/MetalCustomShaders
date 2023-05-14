//
//  UIStackView.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#if !os(macOS)
import UIKit

extension UIStackView {
    
    /// Initializes a new `UIStackView` with the specified axis.
    ///
    /// - Parameter axis: The axis along which the arranged views are laid out.
    public convenience init(axis: NSLayoutConstraint.Axis) {
        self.init()
        self.axis = axis
    }
    
    /// Adds multiple views as arranged subviews to the stack view.
    ///
    /// - Parameter subviews: The views to be added as arranged subviews.
    public func addArrangedSubviews(_ subviews: UIView...) {
        addArrangedSubviews(subviews)
    }
    
    /// Adds an array of views as arranged subviews to the stack view.
    ///
    /// - Parameter subviews: The array of views to be added as arranged subviews.
    public func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addArrangedSubview($0)
        }
    }
    
    /// Removes all arranged subviews from the stack view.
    public func removeArrangedSubviews() {
        let views = arrangedSubviews
        views.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
#endif
