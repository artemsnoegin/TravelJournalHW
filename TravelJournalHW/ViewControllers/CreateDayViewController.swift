//
//  CreateDayVC.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 06.11.2025.
//

import UIKit
import Photos
import PhotosUI

class CreateDayViewController: UIViewController {
    
    var completion: ((Day) -> Void)?
    
    private var trip: Trip
    
    private var dayImages = [UIImage]()
    private var dayName = ""
    private var dayAbout = ""
    
    private let imageCollectionView = DayImagesCollectionView()
    
    private let loadImagesButton = UIButton()
    private let saveButton = UIButton()
    
    private var animatedConstraint: NSLayoutConstraint?
    
    private let textView = CustomTextView()
    
    init(trip: Trip) {
        self.trip = trip
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        subscribeNotification()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        imageCollectionView.alpha = 0
        
        textView.delegate = self
        textView.setTitlePlaceholder(to: "Give day a name")
        textView.setBodyPlaceholder(to: "Add day description")
        textView.isEditing(true)
        
        loadImagesButton.configuration = .tinted()
        loadImagesButton.setTitle("Load Images", for: .normal)
        loadImagesButton.addTarget(self, action: #selector(loadImages), for: .touchUpInside)
        
        saveButton.configuration = .filled()
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .systemGreen
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [textView, loadImagesButton, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        
        view.addSubview(imageCollectionView)
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        animatedConstraint = contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        animatedConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalTo: imageCollectionView.widthAnchor),
            
            loadImagesButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc private func loadImages() {
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .images
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        
        if let sheet = imagePicker.sheetPresentationController {
            
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(imagePicker, animated: true)
    }
    
    @objc private func saveTapped() {
        
        let dayId = UUID()
        let directory = ImageFileManager.shared.createDirectory(dayId.uuidString)
        
        dayImages.enumerated().forEach { number, image in
            
        ImageFileManager.shared.saveImage(image, directoryPath: directory, fileName: String(number))
        }
        
        let day = CoreDataManager.shared.createDay(name: dayName, about: dayAbout, trip: trip, imagesDirectoryPath: directory.absoluteString)
        
        completion?(day)
        
        navigationController?.popViewController(animated: true)
    }
    
    private func subscribeNotification() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }
        
        saveButton.alpha = 0
        loadImagesButton.alpha = 0
        imageCollectionView.alpha = 0
        
        if !dayImages.isEmpty {
            
            animatedConstraint?.constant = 0
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) {
            
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        saveButton.alpha = 1
        loadImagesButton.alpha = 1
        imageCollectionView.alpha = 1
        
        if !dayImages.isEmpty {
            
            animatedConstraint?.constant = view.frame.width
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension CreateDayViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        results.forEach { result in
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
                
                if let image = object as? UIImage {
                    
                    DispatchQueue.main.async {
                        
                        self?.dayImages.append(image)
                        self?.imageCollectionView.images.append(image)
                        self?.imageCollectionView.reloadData()
                        // TODO: change images logic
                        self?.loadImagesButton.isHidden = true
                    }
                }
            }
        }
        
        if !dayName.isEmpty && !dayAbout.isEmpty {
            saveButton.isEnabled = true
        }
        
        animatedConstraint?.constant = view.frame.width
        imageCollectionView.alpha = 1
        
        if let picker = picker.sheetPresentationController {
            
            picker.animateChanges {
                
                view.layoutIfNeeded()
            }
        }
        
        dismiss(animated: true)
    }
}

extension CreateDayViewController: CustomTextViewDelegate {
    
    func titleDidChange(text: String) {

        dayName = text
    
        if !imageCollectionView.images.isEmpty, !dayName.isEmpty && !dayAbout.isEmpty {
            
            saveButton.isEnabled = true
        }
        else {
            
            saveButton.isEnabled = false
        }
    }
    
    func bodyDidChange(text: String) {

        dayAbout = text
        
        if !imageCollectionView.images.isEmpty , !dayName.isEmpty && !dayAbout.isEmpty {
            
            saveButton.isEnabled = true
        }
        else {
            
            saveButton.isEnabled = false
        }
    }
}

