//
//  CustomPhotoPicker.swift
//  Navigation
//
//  Created by Toha Shilin on 16.02.26.
//

import UIKit

class CustomPhotoPickerDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private let handleChoosedImage: (UIImage) -> Void

    init(handleChoosedImage: @escaping (UIImage) -> Void) {
        self.handleChoosedImage = handleChoosedImage
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            handleChoosedImage(image)
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

