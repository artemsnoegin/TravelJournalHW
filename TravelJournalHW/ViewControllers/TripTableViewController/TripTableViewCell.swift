//
//  TripTableViewCell.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 03.11.2025.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    static let reuseId = "TripTableViewCell"
    
    private let mainImageView = UIImageView()
    private let textView = CustomTextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for trip: Trip, isEditing editing: Bool) {
        
        if let imagePath = trip.imagePath,
           let image = ImageFileManager.shared.loadImage(imagePath: imagePath) {
            mainImageView.image = image
        }
        
        textView.setTitlePlaceholder(to: "Give trip a name")
        textView.setTitle(to: trip.name ?? "Trip")
        textView.setBodyPlaceholder(to: "Describe trip")
        textView.setBody(to: trip.about ?? "")
        textView.isEditing(editing)
    }
    
    private func setupUI() {
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.backgroundColor = .lightGray
        
        contentView.addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor),
            
            textView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
