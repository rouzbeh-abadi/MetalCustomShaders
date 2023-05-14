//
//  StackView.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#if !os(macOS)
import Foundation
import UIKit

open class StackView: UIStackView {

   public override init(frame: CGRect) {
      var adjustedFrame = frame
      if frame.size.width == 0 {
         adjustedFrame.size.width = CGFloat.leastNormalMagnitude
      }
      if frame.size.height == 0 {
         adjustedFrame.size.height = CGFloat.leastNormalMagnitude
      }
      super.init(frame: adjustedFrame)
   }

   public required init(coder aDecoder: NSCoder) {
      fatalError()
   }
}
#endif
