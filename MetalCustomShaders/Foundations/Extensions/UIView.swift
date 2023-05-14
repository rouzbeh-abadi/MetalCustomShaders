//
//  UIView.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import Foundation
import UIKit

extension UIView {
    
    /// Enables auto layout for the view.
    ///
    /// - Returns: The view itself after enabling auto layout.
    @discardableResult
    public func autoLayoutView() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
