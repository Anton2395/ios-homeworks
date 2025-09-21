//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 28.07.25.
//
import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    private var images: [UIImage] = []
    private var imagePublisherFacade: ImagePublisherFacade?
    private var isSubscribed = false
    
    private lazy var collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellReuseID.base.rawValue)
        
        return view
    }()
    
    private enum CollectionCellReuseID: String {
        case base = "PhotosCollectionViewCell_ReuseID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupSubviews()
        setupLayouts()
        
        
        imagePublisherFacade = ImagePublisherFacade()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        if !isSubscribed {
            imagePublisherFacade?.subscribe(self)
            isSubscribed = true
            
            let galleryImages = Gallery.make().compactMap { UIImage(named: $0.imageName) }
            imagePublisherFacade?.addImagesWithTimer(
                time: 0.5,
                repeat: galleryImages.count,
                userImages: galleryImages
            )
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if isSubscribed {
            imagePublisherFacade?.removeSubscription(for: self)
            isSubscribed = false
        }
    }
    
    deinit {
        if isSubscribed {
            imagePublisherFacade?.removeSubscription(for: self)
        }
    }
        
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Photo Gallery"
    }

    private func setupSubviews() {
        setupCollectionView()
    }
        
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupLayouts() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        images.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionCellReuseID.base.rawValue,
            for: indexPath) as! PhotosCollectionViewCell
        
        let photo = images[indexPath.row]
        cell.setup(with: photo)
        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    private func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = 3
        let totalSpacing = 2 * spacing + (itemsInRow - 1) * spacing
        let availableWidth = width - totalSpacing
        return availableWidth / itemsInRow
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing: CGFloat = 8.0
        let width = itemWidth(for: collectionView.frame.width, spacing: spacing)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 8.0,
            left: 8.0,
            bottom: 8.0,
            right: 8.0
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        8.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8.0
    }
}

extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        DispatchQueue.main.async {
            for image in images {
                let insertIndex = self.images.count
                self.images.append(image)
                let indexPath = IndexPath(item: insertIndex, section: 0)
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: [indexPath])
                }, completion: nil)
            }
        }
    }
}
