//
//  CreateTripViewController.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 05.11.2025.
//

import UIKit
import Photos
import PhotosUI

class CreateTripViewController: UIViewController, PHPickerViewControllerDelegate {
    
    var completion: ((Trip) -> Void)?
    
    private var tripImage: UIImage?
    private var tripName: String = ""
    private var tripAbout: String = ""
    
    private let imageView = UIImageView()
    private var imageViewHeight: CGFloat = 0
    
    private let loadImageButton = UIButton()
    private let continueButton = UIButton()
    
    private let contentView = UIView()
    private var animatedConstraint: NSLayoutConstraint?
    
    private let textView = CustomTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = .systemBackground
        
        imageView.image = tripImage
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self
        textView.setTitlePlaceholder(to: "Give trip a name")
        textView.setBodyPlaceholder(to: "Add trip description")
        
        loadImageButton.configuration = .tinted()
        loadImageButton.setTitle("Load Image", for: .normal)
        loadImageButton.addTarget(self, action: #selector(loadImage), for: .touchUpInside)
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.configuration = .filled()
        continueButton.tintColor = .systemGreen
        continueButton.isEnabled = false
        
        let stackView = UIStackView(arrangedSubviews: [textView, loadImageButton, continueButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 16
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        animatedConstraint = contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top)
        animatedConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            loadImageButton.heightAnchor.constraint(equalToConstant: 60),
            continueButton.heightAnchor.constraint(equalToConstant: 60),
            
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
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
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let provider = results.first?.itemProvider else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            
            if let image = object as? UIImage {
                
                DispatchQueue.main.async {
                    
                    self?.imageView.image = image
                    self?.loadImageButton.setTitle("Change Image", for: .normal)
                }
            }
        }
        
        if !tripName.isEmpty && !tripAbout.isEmpty {
            continueButton.isEnabled = true
        }
        
        if let picker = picker.sheetPresentationController {
            
            picker.animateChanges {
                
                animatedConstraint?.constant = view.frame.width - 20
            }
        }
        
        dismiss(animated: true)
    }
}

extension CreateTripViewController: CustomTextViewDelegate {
    
    func titleDidChange(text: String) {

        tripName = text
    
        if imageView.image != nil, !tripName.isEmpty && !tripAbout.isEmpty {
            
            continueButton.isEnabled = true
        }
        else {
            continueButton.isEnabled = false
        }
    }
    
    func bodyDidChange(text: String) {

        tripAbout = text
        
        if imageView.image != nil, !tripName.isEmpty && !tripAbout.isEmpty {
            
            continueButton.isEnabled = true
        }
        else {
            continueButton.isEnabled = false
        }
    }
}
