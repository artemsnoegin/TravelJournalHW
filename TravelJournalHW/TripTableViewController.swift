//
//  TripTableViewController.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 02.11.2025.
//

import UIKit

struct Trip {
    
    var name: String
    var about: String
    var image: UIImage
    var days: [Day]
}

struct Day {
    
    var name: String
    var about: String
    var images: [UIImage]
}

class TripTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    private var tripMock: Trip = Trip(
        name: "Baku, Azerbaijan",
        about: "The capital and largest city of Azerbaijan, located on the Caspian Sea. It is also a major center for oil production.",
        image: UIImage(),
        days: [
            Day(name: "Day 1", about: "It was very fun!", images: [UIImage(), UIImage(), UIImage()]),
            Day(name: "Day 2", about: "It was very fun!", images: [UIImage(), UIImage(), UIImage()]),
            Day(name: "Day 3", about: "It was very fun!", images: [UIImage(), UIImage(), UIImage()]),
            Day(name: "Day 4", about: "It was very fun!", images: [UIImage(), UIImage(), UIImage()]),
            Day(name: "Day 5", about: "It was very fun!", images: [UIImage(), UIImage(), UIImage()]),
        ])
    
    private var trip: Trip
    
    init(trip: Trip) {
        
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            
        navigationItem.rightBarButtonItems = [addButton]
    }
    
    @objc private func addTapped() {
        let createDayViewController = CreateDayViewController()
        
        createDayViewController.completion = { [weak self] day in
            
            self?.trip.days.append(day)
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(createDayViewController, animated: true)
    }
    
    private func setupTableView() {
        
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.isPagingEnabled = true
        
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: TripTableViewCell.reuseId)
        tableView.register(DayTableViewCell.self, forCellReuseIdentifier: DayTableViewCell.reuseId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            1
        }
        else {
            trip.days.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let tripCell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.reuseId, for: indexPath) as! TripTableViewCell
            tripCell.selectionStyle = .none
            tripCell.configure(for: trip)
            return tripCell
        }
        else {
            
            let dayCell = tableView.dequeueReusableCell(withIdentifier: DayTableViewCell.reuseId, for: indexPath) as! DayTableViewCell
            dayCell.selectionStyle = .none
            dayCell.configure(for: trip.days[indexPath.row])
            return dayCell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.height
    }
}
