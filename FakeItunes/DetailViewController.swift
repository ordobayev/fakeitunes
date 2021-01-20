//
//  DetailViewController.swift
//  FakeItunes
//
//  Created by Нургазы on 16/12/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        priceButton.layer.cornerRadius = 6
        
        updateUI()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)

    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func priceTapped(_ sender: UIButton) {
        if let url = URL(string: searchResult.storeURL) {
            print(searchResult.storeURL)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    deinit {
        print("______ DEINIT _______")
        downloadTask?.cancel()
    }
    
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artist.isEmpty {
            artistLabel.text = "Unknown"
        } else {
            artistLabel.text = searchResult.artist
        }
        
        kindLabel.text = searchResult.itemType
        genreLabel.text = searchResult.genre
        

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        
        var priceText = ""
        
        if searchResult.price == 0 {
            priceText = "Free"
        } else {
            priceText = formatter.string(from: searchResult.price as NSNumber) ?? ""
        }
        
        priceButton.setTitle(priceText, for: .normal)
        
        // image
        
        if let largeURL = URL(string: searchResult.imageLarge ?? "") {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
        
        
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === self.view
    }
}
