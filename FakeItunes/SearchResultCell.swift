//
//  SearchResultCell.swift
//  FakeItunes
//
//  Created by Нургазы on 27/11/20.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    var downloadTask: URLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = view
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        
        if result.artist.isEmpty {
            artistNameLabel.text = "(\(result.itemType)) Unknown"
        } else {
            artistNameLabel.text = "(\(result.itemType)) \(result.artist)"
        }
        
        artworkImageView.image = UIImage(systemName: "square")
        
        if let smallURL = URL(string: result.imageSmall ?? "") {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
    }
}
