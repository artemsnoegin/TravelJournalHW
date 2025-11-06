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
        
        mainImageView.image = trip.image
        nameTextView.text = trip.name
        aboutTextView.text = trip.about
    }
    
    private func setupUI() {
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.backgroundColor = .lightGray
        
        contentView.addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
    
        nameTextView.font = .preferredFont(forTextStyle: .extraLargeTitle)
        nameTextView.textContainerInset = .zero
        nameTextView.isScrollEnabled = false
        
        aboutTextView.font = .preferredFont(forTextStyle: .title3)
        aboutTextView.textContainerInset = .zero
        aboutTextView.isScrollEnabled = false
        
        let spacer = UIView()
        
//        let stackView = UIStackView(arrangedSubviews: [nameTextView, aboutTextView])
//        stackView.axis = .vertical
//        stackView.spacing = 8
//        
//        contentView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: contentView.frame.width),
            
//            stackView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 16),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
