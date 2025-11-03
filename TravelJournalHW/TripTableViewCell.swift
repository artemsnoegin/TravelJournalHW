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
    private let nameLabel = UILabel()
    private let aboutLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for trip: Trip) {
        
        headerImageView.backgroundColor = trip.image
        nameLabel.text = trip.name
        aboutLabel.text = trip.about
    }
    
    private func setupUI() {
           
        addSubview(headerImageView)
        headerImageView.translatesAutoresizingMaskIntoConstraints = false
    
        nameLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        nameLabel.numberOfLines = 2
        
        aboutLabel.font = .preferredFont(forTextStyle: .title3)
        aboutLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, aboutLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(aboutLabel)
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let spacer = UIView()
        addSubview(spacer)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: frame.width),
            
            stackView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: spacer.topAnchor),
            
            spacer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
