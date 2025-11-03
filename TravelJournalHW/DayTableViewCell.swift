//
//  DayTableViewCell.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 03.11.2025.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    
    static let reuseId = "DayTableViewCell"
    
    private let nameLabel = UILabel()
    private let aboutLabel = UILabel()
    private let imageCollectionView = ImageCollectionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    func configure(for day: Day) {
        
        nameLabel.text = day.name
        aboutLabel.text = day.about
        imageCollectionView.images = day.images
    }
    
    private func setupUI() {
        
        nameLabel.font = .preferredFont(forTextStyle: .extraLargeTitle2)
        aboutLabel.font = .preferredFont(forTextStyle: .title3)
        
        let spacer = UIView()

        [nameLabel, aboutLabel, imageCollectionView, spacer].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: imageCollectionView.topAnchor, constant: -8),
            
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: frame.width),
            
            aboutLabel.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 8),
            aboutLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            aboutLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aboutLabel.bottomAnchor.constraint(equalTo: spacer.topAnchor, constant: -16),
            
            spacer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
