//
//  DispatchUntil.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import Foundation

/// A utility class for performing operations until a fulfillment condition is met.
public final class DispatchUntil {

   private var mIsFulfilled = false

   /// A Boolean value indicating whether the fulfillment condition is met.
   public var isFulfilled: Bool {
      return mIsFulfilled
   }

   /// Initializes a new `DispatchUntil` instance.
   public init() {}
}

extension DispatchUntil {

   /// Performs the specified block of code if the fulfillment condition is not yet met.
   ///
   /// - Parameter block: The block of code to be performed.
   public func performIfNeeded(block: () -> Void) {
      if !mIsFulfilled {
         block()
      }
   }

   /// Fulfills the fulfillment condition, marking it as fulfilled.
   public func fulfill() {
      if !mIsFulfilled {
         mIsFulfilled = true
      }
   }
}
