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
    var hasSearched = false
    var isLoading = false
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
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
        let cellLoading = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellLoading, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        searchBar.becomeFirstResponder()
    
    }
    
    // MARK: - Helper methods
    
    func itunesURL(searchText: String) -> URL {
        // http vs https (secured)
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let urlString = String(format: "http://itunes.apple.com/search?term=%@&limit=200", encodedText!)
        
        let url = URL(string: urlString)
        return url!
    }
    // Unicode (utf-8) or ASCII
    
    func performItunesRequest(with url: URL) -> Data? {
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("ERROR: Cannot download - \(error.localizedDescription)")
            shownNetworkError()
            return nil
        }
        
    }
    
    // decoding, serialization, parsing -> JSON -> Object
    func parse(data: Data) -> [SearchResult] {
        let decoder = JSONDecoder()
        do {
            let results = try decoder.decode(SearchResponse.self, from: data)
            return results.results
        } catch {
            print("JSON parsing error \(error.localizedDescription)")
            return []
        }
    }
    
    func shownNetworkError() {
        let alert = UIAlertController(title: "Error", message: "There was an error accessing the Itunes Store. Please try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}


// MARK: = SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) { // executes on MAIN thread (queue)
        
        searchBar.resignFirstResponder() // 0
        searchResults = [] // 0
        
        isLoading = true // 0
        tableView.reloadData() // 0
        
        hasSearched = true // 0
        
        let queue = DispatchQueue.global()
        
        let url = itunesURL(searchText: searchBar.text!) // 0
        print("------URL - \(url)-----")
        
        queue.async {
            if let data = self.performItunesRequest(with: url) { // 0 - 30
                self.searchResults = self.parse(data: data) // 0 - 2
                self.searchResults.sort { (result1, result2) -> Bool in // 0 - 1
                    return result1.name.localizedStandardCompare(result2.name) == .orderedAscending
                }

                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tableView.reloadData()
      
                }
                return
            }
        }
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
}

// MARK: - TableView DataSource & Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading == true {
            return 1
        } else if hasSearched == false {
            return 0
        } else if hasSearched == true && searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            
            return cell
            
        } else if searchResults.count == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            let searchResult = searchResults[indexPath.row]
            
            cell.nameLabel.text = searchResult.name
            if searchResult.artist.isEmpty {
                cell.artistNameLabel.text = "(\(searchResult.itemType)) Unknown"
            } else {
                cell.artistNameLabel.text = "(\(searchResult.itemType)) \(searchResult.artist)"
            }
            
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

// Synchronous (CPU - Main, extra threads)
// Asynchronous
// GCD - Grand Central Dispatch -> task (closures)
// TASK Priority - High, Medium , Low


/*
 let queue - DispatchQueue.global()
 
 queue.async {
    code that needs to run in the background
 
    DispatchQueue.main.async {
        // update the user interface
 
    }
}
 
 
 */
