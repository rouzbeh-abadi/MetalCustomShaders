//
//  AppCoordinator.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import Foundation
import UIKit

public class AppCoordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    public func setupRootViewController() {
        presentImageProcessingVC()
    }
}

// MARK: - Present ImageProcessingViewController

extension AppCoordinator {
    
    private func presentImageProcessingVC() {
        let vc = ImageProcessingViewController()
        window.rootViewController = vc
    }
}
