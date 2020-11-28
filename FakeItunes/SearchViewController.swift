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
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
        
        struct NameConstants {
            static let noResult = "Nothing Found"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        
        let cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        let cellNFNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNFNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        searchBar.becomeFirstResponder()
    
    }
    
    // MARK: - Helper methods
    
    func itunesURL(searchText: String) -> URL {
        // http vs https (secured)
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlString = String(format: "http://itunes.apple.com/search?term=%@", encodedText!)
        
        let url = URL(string: urlString)
        return url!
    }
    // Unicode (utf-8) or ASCII
    
    func performItunesRequest(with url: URL) -> String? {
        do {
            let string = try String(contentsOf: url, encoding: .utf8)
            return string
        } catch {
            print("ERROR: Cannot download - \(error.localizedDescription)")
            return nil
        }
        
    }
    
}

// MARK: = SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults = []
        
        hasSearched = true
        
        let url = itunesURL(searchText: searchBar.text!)
        print("------URL - \(url)-----")
        
        if let jsonString = performItunesRequest(with: url) {
            print(jsonString)
        }
        
        tableView.reloadData()
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
        
        if searchResults.count == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            cell.nameLabel.text = searchResults[indexPath.row].name
            cell.artistNameLabel.text = searchResults[indexPath.row].artistName
            
            return cell
        }
        
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
// EXC_BAD_ACCESS
// EXC_BREAKPOINT

// CLIENT ----> SERVER
// CLIENT (App) ----> HTTP request -----> Server (Itunes)    (GET POST)
// CLIENT (App) <----- Data(JSON, XML) <----- Server

// Client Aslan (WhatsApp) ---X---> Client Bakyt (WhatsApp)
// Client Aslan (Whatsapp) ---(post)---> Server (Facebook) ----> Client Bakyt (Whatsapp)

// facebook.com (Safari) -> HTML, CSS, JavaScript (site) (Client) ------> Server (GET)

/*
 JSON - JavaScript Object Notation
 
 { } - Dictionary
 [ ] - Array
 */
