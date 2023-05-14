//
//  ViewController.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

#if !os(macOS)
import UIKit

open class ViewController: UIViewController {
    
    public let contentView: View
    private let layoutUntil = DispatchUntil()
    private let setupConstraintsOnce = DispatchOnce()
    private var isInitiatedFromCoder = false
    private var supportedInterfaceOrientationsValue: UIInterfaceOrientationMask?
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return supportedInterfaceOrientationsValue ?? super.supportedInterfaceOrientations
    }
    
    open override func loadView() {
        super.loadView()
        if !isInitiatedFromCoder {
            view = contentView
            contentView.backgroundColor = .white
        }
    }
    
    public init(view: View) {
        contentView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    public init() {
        contentView = View()
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        contentView = View()
        isInitiatedFromCoder = true
        super.init(coder: coder)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUntil.performIfNeeded {
            setupLayoutDefaults()
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        layoutUntil.fulfill()
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupStackViews()
        setupUI()
        setupNavigationUI()
        setupDataSource()
        setupHandlers()
        setupNotificationHandlers()
        setupDefaults()
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraintsOnce.perform {
            setupLayout()
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Below fix is disabled because it wasn't working on my side.
        // I ended up with UIBarButtonItem with custom view (UIButton) inside.
        // applyBarButtonsTintIssueFix()
    }
    
    @objc open dynamic func setupStackViews() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupUI() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupNavigationUI() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupLayout() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupNotificationHandlers() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupHandlers() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupDefaults() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupDataSource() {
        // Base class does nothing.
    }
    
    @objc open dynamic func setupLayoutDefaults() {
        // Base class does nothing.
    }
    
    public final func setSupportedInterfaceOrientations(_ value: UIInterfaceOrientationMask?) {
        supportedInterfaceOrientationsValue = value
    }
}

extension ViewController {
    

    private func applyBarButtonsTintIssueFix() {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
}
#endif
