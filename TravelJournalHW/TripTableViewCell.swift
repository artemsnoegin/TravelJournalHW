//
//  TripTableViewCell.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 03.11.2025.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    
    static let reuseId = "TripTableViewCell"
    
    private let headerImageView = UIView()
    private let nameTextView = UITextView()
    private let aboutTextView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for trip: Trip) {
        
        headerImageView.backgroundColor = trip.image
        nameTextView.text = trip.name
        aboutTextView.text = trip.about
    }
    
    private func setupUI() {
           
        contentView.addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
    
        nameTextView.font = .preferredFont(forTextStyle: .extraLargeTitle)
        nameTextView.textContainerInset = .zero
        nameTextView.isScrollEnabled = false
        
        aboutTextView.font = .preferredFont(forTextStyle: .title3)
        aboutTextView.textContainerInset = .zero
        aboutTextView.isScrollEnabled = false
        
        let stackView = UIStackView(arrangedSubviews: [nameTextView, aboutTextView])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIView()
        contentView.addSubview(spacer)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: frame.width),
            
            stackView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: spacer.topAnchor),
            
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
