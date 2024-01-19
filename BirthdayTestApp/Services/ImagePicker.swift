//
//  ImagePicker.swift
//  BirthdayTestApp
//
//  Created by Konstantin Bondar on 19.01.2024.
//

import UIKit

protocol ImagePickerDelegate: AnyObject {
    func didSelectImage(_ image: UIImage)
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private weak var presentingViewController: UIViewController?
    
    private var imagePicker = UIImagePickerController()
    private weak var delegate: ImagePickerDelegate?
    
    init(presentingViewController: UIViewController, delegate: ImagePickerDelegate) {
        super.init()
        self.presentingViewController = presentingViewController
        self.delegate = delegate
    }
    
    func presentImagePicker() {
        guard let presentingViewController = presentingViewController else { return }
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .overFullScreen
        imagePicker.modalTransitionStyle = .crossDissolve
        
        presentingViewController.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            delegate?.didSelectImage(pickedImage)
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.didSelectImage(pickedImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
