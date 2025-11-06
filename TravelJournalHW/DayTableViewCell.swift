//
//  DayTableViewCell.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 03.11.2025.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    
    static let reuseId = "DayTableViewCell"
    
    private let nameTextField = UITextField()
    private let aboutTextView = UITextView()
    private let imageCollectionView = ImageCollectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func configure(for day: Day) {
        
        nameTextField.text = day.name
        aboutTextView.text = day.about
        imageCollectionView.images = day.images
    }
    
    private func setupUI() {
        
        nameTextField.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        nameTextField.placeholder = "Day"
        
        aboutTextView.font = .preferredFont(forTextStyle: .title3)
        aboutTextView.textContainerInset = .zero
        aboutTextView.isScrollEnabled = false
        
        let spacer = UIView()

        [nameTextField, aboutTextView, imageCollectionView, spacer].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.bottomAnchor.constraint(equalTo: imageCollectionView.topAnchor, constant: -8),
            
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: frame.width),
            
            aboutTextView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 8),
            aboutTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            aboutTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aboutTextView.bottomAnchor.constraint(equalTo: spacer.topAnchor, constant: -16),
            
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
