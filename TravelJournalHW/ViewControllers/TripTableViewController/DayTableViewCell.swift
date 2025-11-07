//
//  DayTableViewCell.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 03.11.2025.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    
    static let reuseId = "DayTableViewCell"
    
    private let imagesCollectionView = DayImagesCollectionView()
    private let textView = CustomTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func configure(for day: Day) {
        
        imagesCollectionView.images = day.images
        imagesCollectionView.reloadData()
        
        textView.setTitle(to: day.name)
        textView.setBodyPlaceholder(to: "Give day a name")
        textView.setBody(to: day.about)
        textView.setBodyPlaceholder(to: "Describe day")
    }
    
    private func setupUI() {
        
        contentView.addSubview(imagesCollectionView)
        imagesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesCollectionView.heightAnchor.constraint(equalTo: imagesCollectionView.widthAnchor),
            
            textView.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
