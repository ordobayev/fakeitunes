//
//  SearchResult.swift
//  FakeItunes
//
//  Created by Нургазы on 25/11/20.
//

import Foundation

class SearchResponse: Codable {
    var resultCount = 0
    var results: [SearchResult] = []
}

class SearchResult: Codable, CustomStringConvertible {

    var trackName: String? = nil
    var artistName: String?
    var trackPrice: Double?
    var kind: String?
    var imageSmall: String?
    var imageLarge: String?
    var itemGenre: String?
    var currency: String?
    var trackViewUrl: String?
    var collectionViewUrl: String?
    var bookName: String?
    var bookPrice: Double?
    var itemPrice: Double?
    var bookGenre: [String]?
    
    // rename attributes
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookName = "collectionName"
        case bookPrice = "collectionPrice"
        case itemPrice = "price"
        case bookGenre = "genres"
        case trackName, artistName, kind
        case trackPrice, currency
        case trackViewUrl, collectionViewUrl
        
    }
    
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    
    var price: Double {
        return trackPrice ?? bookPrice ?? itemPrice ?? 0.0
    }
    
    var itemType: String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-Book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: return "Unknown"
        }
    }
    
    var name: String {
        return trackName ?? bookName ?? ""
    }
    
    var artist: String {
        return artistName ?? ""
    }
    
    var description: String {
        return "\n Result - Kind: \(self.kind ?? "no type") Name: \(self.name), Artist Name: \(self.artistName ?? "no name")"
    }
    
}


/*
 JSON - JavaScript Object Notation -> Swift object (class, struct)
 
 { } - Dictionary
 [ ] - Array
 
 Kinds of SearchResult: song, audioBooks, software, podcast, musicVideos, tvShow, e-books, movies, shortfilms
 
 [
 
 {
   "wrapperType": "track",
   "kind": "song",
   "artistId": 67291928,
   "collectionId": 544099995,
   "trackId": 544100098,
   "artistName": "Bonnie \"Prince\" Billy",
   "collectionName": "Summer in the Southeast (Live)",
   "trackName": "Pushkin (Live)",
   "collectionCensoredName": "Summer in the Southeast (Live)",
   "trackCensoredName": "Pushkin (Live)",
   "artistViewUrl": "https://music.apple.com/us/artist/bonnie-prince-billy/67291928?uo=4",
   "collectionViewUrl": "https://music.apple.com/us/album/pushkin-live/544099995?i=544100098&uo=4",
   "trackViewUrl": "https://music.apple.com/us/album/pushkin-live/544099995?i=544100098&uo=4",
   "previewUrl": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview113/v4/a4/18/43/a4184389-4870-34c9-58ab-5e6139614f54/mzaf_14769404918873757381.plus.aac.p.m4a",
   "artworkUrl30": "https://is3-ssl.mzstatic.com/image/thumb/Music123/v4/3f/64/49/3f644945-775c-068d-2936-32598ca3d86c/source/30x30bb.jpg",
   "artworkUrl60": "https://is3-ssl.mzstatic.com/image/thumb/Music123/v4/3f/64/49/3f644945-775c-068d-2936-32598ca3d86c/source/60x60bb.jpg",
   "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music123/v4/3f/64/49/3f644945-775c-068d-2936-32598ca3d86c/source/100x100bb.jpg",
   "collectionPrice": 9.99,
   "trackPrice": 0.99,
   "releaseDate": "2005-11-15T12:00:00Z",
   "collectionExplicitness": "notExplicit",
   "trackExplicitness": "notExplicit",
   "discCount": 1,
   "discNumber": 1,
   "trackCount": 17,
   "trackNumber": 2,
   "trackTimeMillis": 255707,
   "country": "USA",
   "currency": "USD",
   "primaryGenreName": "Singer/Songwriter",
   "isStreamable": true
 },
 
     {
       "wrapperType": "track",
       "kind": "podcast",
       "artistId": 1465988663,
       "collectionId": 1119389968,
       "trackId": 1119389968,
       "artistName": "Pushkin Industries",
       "collectionName": "Revisionist History",
       "trackName": "Revisionist History",
       "collectionCensoredName": "Revisionist History",
       "trackCensoredName": "Revisionist History",
       "artistViewUrl": "https://podcasts.apple.com/us/artist/pushkin-industries/1465988663?uo=4",
       "collectionViewUrl": "https://podcasts.apple.com/us/podcast/revisionist-history/id1119389968?uo=4",
       "feedUrl": "https://feeds.megaphone.fm/revisionisthistory",
       "trackViewUrl": "https://podcasts.apple.com/us/podcast/revisionist-history/id1119389968?uo=4",
       "artworkUrl30": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/10/b4/f9/10b4f94c-c484-7dcd-8c40-10b142b42ab9/mza_6334207016816396690.jpg/30x30bb.jpg",
       "artworkUrl60": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/10/b4/f9/10b4f94c-c484-7dcd-8c40-10b142b42ab9/mza_6334207016816396690.jpg/60x60bb.jpg",
       "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/10/b4/f9/10b4f94c-c484-7dcd-8c40-10b142b42ab9/mza_6334207016816396690.jpg/100x100bb.jpg",
       "collectionPrice": 0,
       "trackPrice": 0,
       "trackRentalPrice": 0,
       "collectionHdPrice": 0,
       "trackHdPrice": 0,
       "trackHdRentalPrice": 0,
       "releaseDate": "2020-09-10T09:00:00Z",
       "collectionExplicitness": "cleaned",
       "trackExplicitness": "cleaned",
       "trackCount": 75,
       "country": "USA",
       "currency": "USD",
       "primaryGenreName": "Society & Culture",
       "contentAdvisoryRating": "Clean",
       "artworkUrl600": "https://is1-ssl.mzstatic.com/image/thumb/Podcasts123/v4/10/b4/f9/10b4f94c-c484-7dcd-8c40-10b142b42ab9/mza_6334207016816396690.jpg/600x600bb.jpg",
       "genreIds": [
         "1324",
         "26"
       ],
       "genres": [
         "Society & Culture",
         "Podcasts"
       ]
     },
 
 {
       "wrapperType": "track",
       "kind": "tv-episode",
       "artistId": 298667925,
       "collectionId": 358858402,
       "trackId": 359671207,
       "artistName": "Gilmore Girls",
       "collectionName": "Gilmore Girls, Season 5",
       "trackName": "But Not As Cute As Pushkin",
       "collectionCensoredName": "Gilmore Girls, Season 5",
       "trackCensoredName": "But Not As Cute As Pushkin",
       "artistViewUrl": "https://itunes.apple.com/us/tv-show/gilmore-girls/id298667925?uo=4",
       "collectionViewUrl": "https://itunes.apple.com/us/tv-season/but-not-as-cute-as-pushkin/id358858402?i=359671207&uo=4",
       "trackViewUrl": "https://itunes.apple.com/us/tv-season/but-not-as-cute-as-pushkin/id358858402?i=359671207&uo=4",
       "previewUrl": "https://video-ssl.itunes.apple.com/itunes-assets/Video128/v4/20/0f/ee/200fee5f-987f-cab1-6153-b4c60a03320b/mzvf_87979799435175350.640x480.h264lc.U.p.m4v",
       "artworkUrl30": "https://is3-ssl.mzstatic.com/image/thumb/Music71/v4/e3/5c/bd/e35cbde9-29eb-1a63-1f8d-ea39f4e1d89b/source/30x30bb.jpg",
       "artworkUrl60": "https://is3-ssl.mzstatic.com/image/thumb/Music71/v4/e3/5c/bd/e35cbde9-29eb-1a63-1f8d-ea39f4e1d89b/source/60x60bb.jpg",
       "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music71/v4/e3/5c/bd/e35cbde9-29eb-1a63-1f8d-ea39f4e1d89b/source/100x100bb.jpg",
       "collectionPrice": 29.99,
       "trackPrice": 1.99,
       "collectionHdPrice": 29.99,
       "trackHdPrice": 2.99,
       "releaseDate": "2004-11-30T08:00:00Z",
       "collectionExplicitness": "notExplicit",
       "trackExplicitness": "notExplicit",
       "discCount": 1,
       "discNumber": 1,
       "trackCount": 22,
       "trackNumber": 10,
       "trackTimeMillis": 2631923,
       "country": "USA",
       "currency": "USD",
       "primaryGenreName": "Drama",
       "shortDescription": "Rory is delighted when Headmaster Hanlin Charleston (DAKIN MATTHEWS) from her old prep school asks her to host a young student, Anna (SARAH FORET), who is thinking of applying to Yale. However, Anna is much more interested in boys than academics and runs off to party, leaving Rory to deal with Logan's (recurring guest star MATT CZUCHRY) elaborate practical jokes. Meanwhile, Lorelai and Luke have their first argument when she upsets him by buying an old boat that had previously belonged to his father.",
       "longDescription": "Rory is delighted when Headmaster Hanlin Charleston (DAKIN MATTHEWS) from her old prep school asks her to host a young student, Anna (SARAH FORET), who is thinking of applying to Yale. However, Anna is much more interested in boys than academics and runs off to party, leaving Rory to deal with Logan's (recurring guest star MATT CZUCHRY) elaborate practical jokes. Meanwhile, Lorelai and Luke have their first argument when she upsets him by buying an old boat that had previously belonged to his father."
     },
 
 {
       "wrapperType": "audiobook",
       "artistId": 445603643,
       "collectionId": 1365011738,
       "artistName": "Alexander Pushkin",
       "collectionName": "Povesti Belkina",
       "collectionCensoredName": "Povesti Belkina",
       "artistViewUrl": "https://books.apple.com/us/author/alexander-pushkin/id445603643?uo=4",
       "collectionViewUrl": "https://books.apple.com/us/audiobook/povesti-belkina/id1365011738?uo=4",
       "artworkUrl60": "https://is5-ssl.mzstatic.com/image/thumb/Music118/v4/35/6b/4e/356b4e47-abfa-9112-bafb-8dafa318a5ca/rm_image.jpg/60x60bb.jpg",
       "artworkUrl100": "https://is5-ssl.mzstatic.com/image/thumb/Music118/v4/35/6b/4e/356b4e47-abfa-9112-bafb-8dafa318a5ca/rm_image.jpg/100x100bb.jpg",
       "collectionPrice": 3.99,
       "collectionExplicitness": "notExplicit",
       "trackCount": 1,
       "copyright": "© 2018 Shishkin Vladislav",
       "country": "USA",
       "currency": "USD",
       "releaseDate": "2018-03-28T07:00:00Z",
       "primaryGenreName": "Classics",
       "previewUrl": "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview123/v4/21/31/5a/21315a0d-356e-c967-ec75-f0ad4c81d87e/mzaf_3450676683159123282.std.aac.p.m4a",
       "description": "\"Povesti Belkina\" - tsikl povestey Aleksandra Sergeevicha Pushkina, sostoyashchiy iz 5 povestey i vypushchennyy im bez ukazaniya imeni nastoyashchego avtora, to est' samogo Pushkina. \"Vystrel\", \"Baryshnya-krest'yanka\" - ispolnyaet Mihail Kazakov, \"Metel\" - ispolnyaet Innokentiy Smoktunovskiy, \"Stantsionnyy smotritel\" - Vladimir Druzhnikov, \"Grobovshchik\" - Vladimir Kenigson."
     },
 
 
 */
