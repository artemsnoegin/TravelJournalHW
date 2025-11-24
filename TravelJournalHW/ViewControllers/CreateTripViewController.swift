//
//  CreateTripViewController.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 05.11.2025.
//

import UIKit
import Photos
import PhotosUI

class CreateTripViewController: UIViewController {
    
    var completion: ((Trip) -> Void)?
    
    private var tripImage = UIImage()
    private var tripName = ""
    private var tripAbout = ""
    
    private let imageView = UIImageView()
    
    private let loadImageButton = UIButton()
    private let saveButton = UIButton()
    
    private var animatedConstraint: NSLayoutConstraint?
    
    private let textView = CustomTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        subscribeNotification()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        
        textView.delegate = self
        textView.setTitlePlaceholder(to: "Give trip a name")
        textView.setBodyPlaceholder(to: "Add trip description")
        textView.isEditing(true)
        
        loadImageButton.configuration = .tinted()
        loadImageButton.setTitle("Load Image", for: .normal)
        loadImageButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        
        saveButton.configuration = .filled()
        saveButton.setTitle("Continue", for: .normal)
        saveButton.tintColor = .systemGreen
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [textView, loadImageButton, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        animatedConstraint = contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        animatedConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            loadImageButton.heightAnchor.constraint(equalToConstant: 60),
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
    
    @objc private func loadImage() {
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
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
        

        let directory = ImageFileManager.shared.createDirectory(tripName)
        let imagePath = ImageFileManager.shared.saveImage(tripImage, directoryPath: directory, fileName: "main")
        let trip = CoreDataManager.shared.createTrip(name: tripName, about: tripAbout, days: [], imagePath: imagePath.absoluteString)
        print(imagePath)
        
        completion?(trip)

        navigationController?.pushViewController(TripTableViewController(trip: trip), animated: true)
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
        loadImageButton.alpha = 0
        imageView.alpha = 0
        
        if tripImage != UIImage() {
            
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
        loadImageButton.alpha = 1
        imageView.alpha = 1
        
        if tripImage != UIImage() {
            
            animatedConstraint?.constant = view.frame.width - view.safeAreaInsets.top
        }

        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn]) {
            
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
}

extension CreateTripViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let provider = results.first?.itemProvider else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            if let image = object as? UIImage {
                
                DispatchQueue.main.async {
                    
                    self?.tripImage = image
                    self?.imageView.image = image
                    self?.loadImageButton.setTitle("Change Image", for: .normal)
                }
            }
        }
        
        if !tripName.isEmpty && !tripAbout.isEmpty {
            saveButton.isEnabled = true
        }
        
        animatedConstraint?.constant = view.frame.width - view.safeAreaInsets.top
        imageView.alpha = 1
        
        if let picker = picker.sheetPresentationController {
            
            picker.animateChanges {
                
                view.layoutIfNeeded()
            }
        }
        
        dismiss(animated: true)
    }
}

extension CreateTripViewController: CustomTextViewDelegate {
    
    func titleDidChange(text: String) {

        tripName = text
    
        if imageView.image != nil, !tripName.isEmpty && !tripAbout.isEmpty {
            
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
        }
    }
    
    func bodyDidChange(text: String) {

        tripAbout = text
        
        if imageView.image != nil, !tripName.isEmpty && !tripAbout.isEmpty {
            
            saveButton.isEnabled = true
        }
        else {
            saveButton.isEnabled = false
        }
    }
}
