//
//  NSLayoutConstraint.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#if !os(macOS)
import UIKit

extension NSLayoutConstraint {

   public func activate(priority: LayoutPriority? = nil) {
      if let priority = priority {
         self.priority = priority
      }
      isActive = true
   }

   public func activate(priority: Float) {
      activate(priority: LayoutPriority(rawValue: priority))
   }
}
#endif
