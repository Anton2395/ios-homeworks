//
//  PostFormViewController.swift
//  Navigation
//
//  Created by Toha Shilin on 18.02.26.
//
import UIKit

class PostFormViewController: UIViewController {
    private enum LocalizedKeys: String {
        case label = "label-post-form-vc"
        case author = "author-post-form-vc"
        case preview = "preview-post-form-vc"
        case likes = "likes-post-form-vc"
        case views = "views-post-form-vc"
        case publish = "publish-button-post-form-vc"
    }
    
    private let handleSavingPost: (String, UIImage) -> Void
    private var imageAspectConstraint: NSLayoutConstraint?
    private var pickerDelegate: CustomPhotoPickerDelegate?

    // MARK: - Scroll

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Title

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ~LocalizedKeys.label.rawValue
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Preview Card

    private lazy var previewCard: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = ~LocalizedKeys.author.rawValue
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imagePostView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ~LocalizedKeys.preview.rawValue
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var likeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(~LocalizedKeys.likes.rawValue): 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.text = "\(~LocalizedKeys.views.rawValue): 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [likeLabel, viewsLabel])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Description Input

    private lazy var descriptionField: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 12
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - Image Picker Button

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Save Button

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle(~LocalizedKeys.publish.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)

        button.backgroundColor = .systemBlue
        button.tintColor = .white

        button.layer.cornerRadius = 14

        button.heightAnchor.constraint(equalToConstant: 50).isActive = true

        button.addTarget(self, action: #selector(pressSave), for: .touchUpInside)

        return button
    }()

    // MARK: - Main Stack

    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            previewCard,
            descriptionField,
            imageView,
            saveButton
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    init(handleSavingPost: @escaping (String, UIImage) -> Void) {
        self.handleSavingPost = handleSavingPost
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupActions()
        setupLayout()
    }

    // MARK: - Actions

    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        imageView.addGestureRecognizer(tap)
    }

    @objc private func tapImage() {

        let picker = UIImagePickerController()

        pickerDelegate = CustomPhotoPickerDelegate { [weak self] image in
            guard let self else { return }

            self.imageView.image = image
            self.imagePostView.image = image

            self.updateImageAspectRatio(image: image)
        }

        picker.delegate = pickerDelegate
        present(picker, animated: true)
    }

    @objc private func pressSave() {

        guard let image = imageView.image else { return }

        handleSavingPost(descriptionField.text ?? "", image)

        dismiss(animated: true)
    }

    // MARK: - Layout

    private func setupLayout() {

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(mainStack)

        previewCard.addSubview(authorLabel)
        previewCard.addSubview(imagePostView)
        previewCard.addSubview(descriptionLabel)
        previewCard.addSubview(statsStack)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            imageView.heightAnchor.constraint(equalToConstant: 180),

            authorLabel.topAnchor.constraint(equalTo: previewCard.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: previewCard.trailingAnchor, constant: -16),

            imagePostView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 12),
            imagePostView.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 16),
            imagePostView.trailingAnchor.constraint(equalTo: previewCard.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: imagePostView.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: previewCard.trailingAnchor, constant: -16),

            statsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            statsStack.leadingAnchor.constraint(equalTo: previewCard.leadingAnchor, constant: 16),
            statsStack.bottomAnchor.constraint(equalTo: previewCard.bottomAnchor, constant: -16)

        ])
    }

    // MARK: - Image Ratio

    private func updateImageAspectRatio(image: UIImage) {

        imageAspectConstraint?.isActive = false

        let ratio = image.size.height / image.size.width

        imageAspectConstraint = imagePostView.heightAnchor.constraint(
            equalTo: imagePostView.widthAnchor,
            multiplier: ratio
        )

        imageAspectConstraint?.isActive = true
    }
}

// MARK: - UITextViewDelegate

extension PostFormViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        descriptionLabel.text = textView.text

        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach {
            if $0.firstAttribute == .height {
                $0.constant = estimatedSize.height
            }
        }
    }
}
