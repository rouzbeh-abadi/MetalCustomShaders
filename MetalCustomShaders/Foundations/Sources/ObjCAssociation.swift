//
//  ObjCAssociation.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import ObjectiveC

public struct ObjCAssociation {

   /// Retrieves the associated value from an object for a given key.
   ///
   /// - Parameters:
   ///   - object: The object to retrieve the associated value from.
   ///   - key: The key used to associate the value.
   /// - Returns: The associated value, or `nil` if there is no association or the associated value is of a different type.
   public static func value<T>(from object: AnyObject, forKey key: UnsafeRawPointer) -> T? {
      return objc_getAssociatedObject(object, key) as? T
   }

   /// Sets an assign (weak) association for a value to an object with a given key.
   ///
   /// - Parameters:
   ///   - value: The value to associate with the object.
   ///   - object: The object to associate the value with.
   ///   - key: The key used to associate the value.
   public static func setAssign<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_ASSIGN)
   }

   /// Sets a retain (strong) non-atomic association for a value to an object with a given key.
   ///
   /// - Parameters:
   ///   - value: The value to associate with the object.
   ///   - object: The object to associate the value with.
   ///   - key: The key used to associate the value.
   public static func setRetainNonAtomic<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
   }

   /// Sets a copy non-atomic association for a value to an object with a given key.
   ///
   /// - Parameters:
   ///   - value: The value to associate with the object.
   ///   - object: The object to associate the value with.
   ///   - key: The key used to associate the value.
   public static func setCopyNonAtomic<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
   }

   /// Sets a retain (strong) association for a value to an object with a given key.
   ///
   /// - Parameters:
   ///   - value: The value to associate with the object.
   ///   - object: The object to associate the value with.
   ///   - key: The key used to associate the value.
   public static func setRetain<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN)
   }

   /// Sets a copy association for a value to an object with a given key.
   ///
   /// - Parameters:
   ///   - value: The value to associate with the object.
   ///   - object: The object to associate the value with.
   ///   - key: The key used to associate the value.
   public static func setCopy<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_COPY)
   }
}
