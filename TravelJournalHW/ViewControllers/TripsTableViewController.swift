//
//  TripsTableViewController.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 07.11.2025.
//

import UIKit

class TripsTableViewController: UITableViewController {
    
    private var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Trips"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        fetchTrips()
    }
    
    private func fetchTrips() {
        
        trips = CoreDataManager.shared.fetchTrips()
        tableView.reloadData()
    }
    
    @objc private func addTapped() {
        
        let createTripVC = CreateTripViewController()
        
        createTripVC.completion = { [weak self] trip in

            self?.trips.append(trip)
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(createTripVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        trips.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        cell.textLabel?.text = trips[indexPath.row].name
        cell.textLabel?.font = .preferredFont(forTextStyle: .title2)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTrip = trips[indexPath.row]
        
        let tripVC = TripTableViewController(trip: selectedTrip)
        navigationController?.pushViewController(tripVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let tripToDelete = trips[indexPath.row]
        CoreDataManager().deleteTrip(tripToDelete)
        trips.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
