//
//  PhotoGalleryHandler.swift
//  MetalCustomShaders
//
//  Created by Rouzbeh Abadi on 13.05.23.
//

import UIKit
import Photos


/// ImagePickerManager is a singleton class used to handle image picking from the gallery or camera.
class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    /// Shared instance of ImagePickerManager
    static let shared = ImagePickerManager()
  
    /// Private initializer to prevent multiple instances
    private override init() {
        super.init()
    }
  
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
  
    /// This function displays an action sheet with options to pick an image from camera or gallery.
    /// - Parameters:
    ///   - viewController: The viewController from which the picker is presented.
    ///   - callback: The callback function to handle the picked image.
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }

  
    /// This function is used to open the camera for image picking.
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController?.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alertWarning.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.viewController?.present(alertWarning, animated: true, completion: nil)
        }
    }
  
    /// This function is used to open the gallery for image picking.
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController?.present(picker, animated: true, completion: nil)
    }
  
    /// This function is the delegate method for image picker. It handles the image picked from the camera or gallery.
    /// - Parameters:
    ///   - picker: The UIImagePickerController instance.
    ///   - info: The dictionary containing the original image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        pickImageCallback?(image)
    }
  
    /// This function is the delegate method for image picker. It handles the cancellation of the picker.
    /// - Parameter picker: The UIImagePickerController instance.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
