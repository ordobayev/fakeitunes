//
//  ViewController.swift
//  FakeItunes
//
//  Created by Нургазы on 25/11/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchResults = [SearchResult]()
    var hasSearched: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
    }

    

}

// MARK: = SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResults = []
        
        if searchBar.text != "Atai" {
        searchResults.append(SearchResult(name: "Fake Result 1", artistName: searchBar.text!))
        searchResults.append(SearchResult(name: "Fake Result 2", artistName: searchBar.text!))
        searchResults.append(SearchResult(name: "Fake Result 3", artistName: searchBar.text!))
        }
        
        hasSearched = true
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
}

// MARK: - TableView DataSource & Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasSearched == false {
            return 0
        } else if hasSearched == true && searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        if searchResults.count == 0 {
            cell.textLabel?.text = "(Nothing Found)"
            cell.detailTextLabel?.text = ""
        } else {
        cell.textLabel?.text = searchResults[indexPath.row].name
        cell.detailTextLabel?.text = searchResults[indexPath.row].artistName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}

// M - Modified
// R - Renamed
// A - Added
// Commit
