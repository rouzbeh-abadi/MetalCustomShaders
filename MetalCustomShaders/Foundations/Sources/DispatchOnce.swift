//
//  DispatchOnce.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import Foundation

/// A utility class for performing an operation only once.
public final class DispatchOnce {

   private var isInitialized = false

   /// Initializes a new `DispatchOnce` instance.
   public init() {}

   /// Performs the specified block of code only once.
   ///
   /// - Parameter block: The block of code to be performed.
   public func perform(block: () -> Void) {
      if !isInitialized {
         block()
         isInitialized = true
      }
   }
}
