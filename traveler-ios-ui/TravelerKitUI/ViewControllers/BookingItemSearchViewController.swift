//
//  BookingItemSearchViewController.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

class BookingItemSearchViewController: UIViewController {
    
    private var searchText: String?
    private var bookingItemResult: BookingItemSearchResult?
    private var searchQuery: BookingItemQuery?
    private var facets: Facets?
    private var previousFilters: BookingItemSearchFilters?

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue", _):
            break
        case (_ , let searchResultsVC as BookingItemSearchResultViewController):
            searchResultsVC.bookingItemResult = bookingItemResult
            searchResultsVC.searchQuery = searchQuery
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension BookingItemSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }

        searchQuery = BookingItemQuery(text: searchText, range: nil, boundingBox: nil)
        Traveler.searchBookingItems(searchQuery: searchQuery!, identifier: nil, delegate: self)
        performSegue(withIdentifier: "loadingSegue", sender: nil)
    }
}

extension BookingItemSearchViewController: BookingItemSearchDelegate {
    func bookingItemSearchDidSucceedWith(_ result: BookingItemSearchResult, identifier: AnyHashable?) {
        switch (facets) {
               case .none:
                   facets = result.facets
               default:
                   break
               }
               bookingItemResult = result
               performSegue(withIdentifier: "searchResultSegue", sender: nil)
    }

    func bookingItemSearchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        performSegue(withIdentifier: "failSegue", sender: nil)
    }
}
