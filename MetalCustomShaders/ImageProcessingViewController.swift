//
//  ImageProcessingViewController.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import UIKit

class ImageProcessingViewController: ViewController {

    private lazy var mainStackView = StackView(axis: .vertical).autoLayoutView()
    private lazy var imageView = UIImageView().autoLayoutView()
    private lazy var selectPhotoButton = UIButton().autoLayoutView()
    
    private lazy var segmentedControl: UISegmentedControl = {
          let items = ["Original", "Derivatives", "Grayscale", "Saturation"]
          let sc = UISegmentedControl(items: items)
          sc.selectedSegmentIndex = 0
          return sc
    }().autoLayoutView()
    
    /// The original, unaltered photo selected by the user.
    /// This variable stores the original selected photo to allow applying filters directly on the original image.
    private var originalUnfilteredPhoto: UIImage?
}

// MARK: - Handlers

extension ImageProcessingViewController {
    
    override func setupHandlers() {
        
        selectPhotoButton.setTouchUpInsideHandler(self) {
            $0.selectImageFromGallery()
        }
        
        segmentedControl.setValueChangedHandler(self) {
            $0.handleSegmentChange()
        }
    }
}

// MARK: - Methods

extension ImageProcessingViewController {
    
    /// Selects an image from the gallery using the `ImagePickerManager` singleton.
    private func selectImageFromGallery() {
        ImagePickerManager.shared.pickImage(self) { [weak self] selectedImage in
            self?.processSelectedImage(selectedImage)
        }
    }

    /// Processes the selected image, updating the UI and setting the state of the application.
    private func processSelectedImage(_ selectedImage: UIImage) {
        self.imageView.image = selectedImage
        self.originalUnfilteredPhoto = selectedImage
        self.showImageControls()
    }

    /// Shows the controls for manipulating the selected image.
    private func showImageControls() {
        self.segmentedControl.isHidden = false
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    
    /// Handles the change of the selected segment in the segmented control.
    ///
    /// This function is called when the selected segment of the segmented control changes.
    /// It checks the `selectedSegmentIndex` property of the segmented control to determine which segment is selected and calls the `applyFilter` function with the corresponding `FilterType`.
    private func handleSegmentChange() {
        let filter: Filter
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            filter = .none
            
        case 1:
            // Blur derivatives selected
            filter = .derivatives
            
        case 2:
            // Grayscale filter selected
            filter = .grayscale
        
        case 3:
            // Saturation filter selected
            // 3 is added just as an example
            filter = .saturation(factor: 1.5)
        default:
            return
        }
        
        applyFilter(filter)
    }
}


// MARK: - Apply filters

extension ImageProcessingViewController {
    
    /// Applies a specified filter to the image in the imageView.
    ///
    /// This function calls the `apply(filter:to:)` function in the `MetalImageProcessing` extension to apply a specified filter to the `originalSelectedPhoto` and display the result in the `imageView`.
    /// - Parameter filter: The type of filter to apply.
    private func applyFilter(_ filter: Filter) {
        guard let originalImage = self.originalUnfilteredPhoto else { return }
        
        do {
            imageView.image = try MetalImageProcessing.shared.apply(filter: filter, to: originalImage)
        } catch {
            print("Failed to apply filter: \(error)")
        }
    }

    
}

// MARK: - setup

extension ImageProcessingViewController {
    
    override func setupStackViews() {
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubviews(imageView, segmentedControl, selectPhotoButton)
        mainStackView.spacing = 30
    }
    
    override func setupUI() {
        view.backgroundColor = .secondarySystemBackground
        
        selectPhotoButton.titleColor = .systemBlue
        selectPhotoButton.title = "Select a photo"
        
        imageView.contentMode = .scaleAspectFit
        
        segmentedControl.isHidden = true
    }
    
    override func setupLayout() {
        mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).activate()
        mainStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20).activate()
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).activate()
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).activate()

    }
}
