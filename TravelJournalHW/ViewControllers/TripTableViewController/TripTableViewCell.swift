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
    
    func configure(for trip: Trip) {
        
        mainImageView.image = trip.image
        textView.setTitle(to: trip.name)
        textView.setBodyPlaceholder(to: "Give trip a name")
        textView.setBody(to: trip.about)
        textView.setBodyPlaceholder(to: "Describe trip")
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
