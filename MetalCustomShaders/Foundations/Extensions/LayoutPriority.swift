//
//  LayoutPriority.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#if os(iOS) || os(tvOS)
import UIKit
public typealias LayoutPriority = UILayoutPriority
#elseif os(OSX)
import AppKit
public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

extension LayoutPriority {

   public static func + (left: LayoutPriority, right: Float) -> LayoutPriority {
      return LayoutPriority(rawValue: left.rawValue + right)
   }

   public static func - (left: LayoutPriority, right: Float) -> LayoutPriority {
      return LayoutPriority(rawValue: left.rawValue - right)
   }
}
