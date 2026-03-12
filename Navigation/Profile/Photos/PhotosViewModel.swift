//
//  PhotosViewModel.swift
//  Navigation
//
//  Created by Toha Shilin on 8.03.26.
//

class PhotosViewModel {
    var images: [GalleryImage] = []
    var reloadCollectionData: (() -> Void)?
    var setNewAvatar: ((ImgBBUploadResult) -> Void)?
    let userImage: String
    
    
    init(userImage: String) {
        self.userImage = userImage
    }
    
    func loadImages() {
        FirebaseService.loadImages { [weak self] galleryImages in
            guard let self = self else { return }
            Task {
                if let images = galleryImages {
                    self.images = images
                    self.reloadCollectionData?()
                }
            }
        }
    }
    
    func addNewImage(_ image: GalleryImage) {
        images.insert(image, at: 0)
        reloadCollectionData?()
    }
    
    func deleteImage(_ image: GalleryImage) {
        Task {
            try await ImgBBService.deleteImage(deleteURL: image.deleteImageURL)
            try await FirebaseService.deleteImage(image)
        }
        images = images.filter { galImage in
            return galImage.imageURL != image.imageURL
        }
        reloadCollectionData?()
    }
}
