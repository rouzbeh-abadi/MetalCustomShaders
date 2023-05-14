//
//  UIControl.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#if !os(macOS)
import UIKit

extension UIControl {
    
    /// A typealias for the closure used as a handler.
    public typealias Handler = (() -> Void)
    
    /// Sets a touchUpInside handler for the control.
    ///
    /// - Parameter handler: The closure to be called when the touchUpInside event occurs.
    public func setTouchUpInsideHandler(_ handler: Handler?) {
        addTarget(self, action: #selector(appUI_touchUpInside(_:)), for: .touchUpInside)
        if let handler = handler {
            ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.touchUpInside)
        }
    }
    
    /// Sets a touchUpInside handler for the control.
    ///
    /// - Parameters:
    ///   - caller: The caller object that will be weakly referenced.
    ///   - handler: The closure to be called when the touchUpInside event occurs.
    public func setTouchUpInsideHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
        setTouchUpInsideHandler { [weak caller] in
            guard let caller = caller else { return }
            handler(caller)
        }
    }
    
    /// Sets a valueChanged handler for the control.
    ///
    /// - Parameter handler: The closure to be called when the valueChanged event occurs.
    public func setValueChangedHandler(_ handler: Handler?) {
        addTarget(self, action: #selector(appUI_valueChanged(_:)), for: .valueChanged)
        if let handler = handler {
            ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.valueChanged)
        }
    }
    
    /// Sets a valueChanged handler for the control.
    ///
    /// - Parameters:
    ///   - caller: The caller object that will be weakly referenced.
    ///   - handler: The closure to be called when the valueChanged event occurs.
    public func setValueChangedHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
        setValueChangedHandler { [weak caller] in
            guard let caller = caller else { return }
            handler(caller)
        }
    }
    
    /// Sets an editingChanged handler for the control.
    ///
    /// - Parameter handler: The closure to be called when the editingChanged event occurs.
    public func setEditingChangedHandler(_ handler: Handler?) {
        addTarget(self, action: #selector(appUI_editingChanged(_:)), for: .editingChanged)
        if let handler = handler {
            ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.editingChanged)
        }
    }
    
    /// Sets an editingChanged handler for the control.
    ///
    /// - Parameters:
    ///   - caller: The caller object that will be weakly referenced.
    ///   - handler: The closure to be called when the editingChanged event occurs.
    public func setEditingChangedHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
        setEditingChangedHandler { [weak caller] in
            guard let caller = caller else { return }
            handler(caller)
        }
    }
    
    /// Sets an editingDidBegin handler for the control.
    ///
    /// - Parameter handler: The closure to be called when the editingDidBegin event occurs.
    public func setEditingDidBeginHandler(_ handler: Handler?) {
        addTarget(self, action: #selector(appUI_editingDidBegin(_:)), for: .editingDidBegin)
        if let handler = handler {
            ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.editingDidBegin)
        }
    }
    
    /// Sets an editingDidBegin handler for the control.
    ///
    /// - Parameters:
    ///   - caller: The caller object that will be weakly referenced.
    ///   - handler: The closure to be called when the editingDidBegin event occurs.
    public func setEditingDidBeginHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
        setEditingDidBeginHandler { [weak caller] in
            guard let caller = caller else { return }
            handler(caller)
        }
    }
    
    /// Sets an editingDidEnd handler for the control.
    ///
    /// - Parameter handler: The closure to be called when the editingDidEnd event occurs.
    public func setEditingDidEndHandler(_ handler: Handler?) {
        addTarget(self, action: #selector(appUI_editingDidEnd(_:)), for: .editingDidEnd)
        if let handler = handler {
            ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.editingDidEnd)
        }
    }
    
    /// Sets an editingDidEnd handler for the control.
    ///
    /// - Parameters:
    ///   - caller: The caller object that will be weakly referenced.
    ///   - handler: The closure to be called when the editingDidEnd event occurs.
    public func setEditingDidEndHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
        setEditingDidEndHandler { [weak caller] in
            guard let caller = caller else { return }
            handler(caller)
        }
    }
}

extension UIControl {
    
    private struct Key {
        static var touchUpInside = "app.ui.touchUpInsideHandler"
        static var valueChanged = "app.ui.valueChangedHandler"
        static var editingChanged = "app.ui.editingChangedHandler"
        static var editingDidBegin = "app.ui.editingDidBeginHandler"
        static var editingDidEnd = "app.ui.editingDidEndHandler"
    }
    
    
    /// An internal method that handles the touchUpInside event.
    ///
    /// - Parameter sender: The UIControl instance that triggered the event.
    @objc private func appUI_touchUpInside(_ sender: UIControl) {
        guard sender == self else {
            return
        }
        if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.touchUpInside) {
            handler()
        }
    }
    
    /// An internal method that handles the valueChanged event.
    ///
    /// - Parameter sender: The UIControl instance that triggered the event.
    @objc private func appUI_valueChanged(_ sender: UIControl) {
        guard sender == self else {
            return
        }
        if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.valueChanged) {
            handler()
        }
    }
    
    /// An internal method that handles the editingChanged event.
    ///
    /// - Parameter sender: The UIControl instance that triggered the event.
    @objc private func appUI_editingChanged(_ sender: UIControl) {
        guard sender == self else {
            return
        }
        if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.editingChanged) {
            handler()
        }
    }
    
    /// An internal method that handles the editingDidBegin event.
    ///
    /// - Parameter sender: The UIControl instance that triggered the event.
    @objc private func appUI_editingDidBegin(_ sender: UIControl) {
        guard sender == self else {
            return
        }
        if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.editingDidBegin) {
            handler()
        }
    }
    
    /// An internal method that handles the editingDidEnd event.
    ///
    /// - Parameter sender: The UIControl instance that triggered the event.
    @objc private func appUI_editingDidEnd(_ sender: UIControl) {
        guard sender == self else {
            return
        }
        if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.editingDidEnd) {
            handler()
        }
    }
}
#endif

