//
//  SearchResult.swift
//  FakeItunes
//
//  Created by Нургазы on 25/11/20.
//

import Foundation

class SearchResult {
    var name: String = ""
    var artistName: String = ""
    
    init(name: String, artistName: String) {
        self.name = name
        self.artistName = artistName
    }
}
