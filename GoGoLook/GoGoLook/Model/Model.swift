//
//  Model.swift
//  Gogolook
//
//  Created by Claud on 2022/4/19.
//

import Foundation

enum UserDefaultKeyName:String {
    case anime = "anime"
    case manga = "manga"
}


enum mangaType:String, Codable {
    case Manga = "Manga"
    case Novel = "Novel"
    case Lightnovel = "Light Novel"
    case OnShot = "One-shot"
    case Doujinshi = "Doujinshi"
    case Manhua = "Manhua"
    case Manhwa = "Manhwa"
    case OEL = "OEL"
}

enum animeType:String, Codable {
    case tv = "TV"
    case movie = "Movie"
    case ova = "OVA"
    case special = "Special"
    case ona = "Ona"
    case music = "Music"
}

enum seasonObj:String, Codable {
    case Summer = "summer"
    case Winter = "winter"
    case Spring = "spring"
    case Fall = "fall"
}

enum animeFilter:String, CodingKey {
    case airing = "airing"
    case upcoming = "upcoming"
    case bypopularity = "bypopularity"
    case favorite = "favorite"
}

enum airingStatus:String, Codable {
    case FinishedAiring = "Finished Airing"
    case CurrentlyAiring = "Currently Airing"
    case NotYetAired = "Not yet aired"
}

enum publishingStatus:String, Codable {
    case Finished = "Finished"
    case Publishing = "Publishing"
    case OnHiatus = "On Hiatus"
    case Discontinued = "Discontinued"
    case NotYetPublished = "Not yet published"
}

struct paginationObj:Codable {
    var last_visible_page:Int?
    var has_next_page:Bool?
    var item:paginationItem?
}

struct paginationItem:Codable {
    var count:Int?
    var total:Int?
    var per_page:Int?
}


struct imagesObj:Codable {
    var jpgObj:imageInfo?
    var webp:imageInfo?
}

struct imageInfo:Codable {
    var image_url:String?
    var small_image_url:String?
    var large_image_url:String?
}

struct propObj:Codable {
    var from:dateProp?
    var to:dateProp?
    var string:String?
}

struct dateProp:Codable{
    var day:Int?
    var month:Int?
    var year:Int?
}

struct trailerObj:Codable {
    var youtube_id:String?
    var url:String?
    var embed_url:String?
}

struct airedObj:Codable {
    var from:String?
    var to:String?
    var prop:propObj?
}

struct publishedObj:Codable {
    var from:String?
    var to:String?
    var prop:propObj?
}

struct mal_idObj:Codable {
    var mal_id:Int?
    var type:String?
    var name:String?
    var url:String?
}

struct broadcastObj:Codable {
    var day:String?
    var time:String?
    var timezone:String?
    var string:String?
}

struct animeData:Codable {
    var mal_id:Int?
    var url:String?
    var imagesObj:imagesObj?
    var trailerObj:trailerObj?
    var title:String?
    var title_english:String?
    var title_japanese:String?
    var title_synonyms:[String]?
    var type:animeType?
    var source:String?
    var episodes:Int?
    var status:airingStatus?
    var airing:Bool?
    var aired:airedObj?
    var duration:String?
    var rating:String?
    var score:Float?
    var scored_by:Int?
    var rank:Int?
    var popularity:Int?
    var members:Int?
    var favorites:Int?
    var synopsis:String?
    var background:String?
    var season:seasonObj?
    var year:Int?
    var broadcast:broadcastObj?
    var producers:[mal_idObj]?
    var licensors:[mal_idObj]?
    var studios:[mal_idObj]?
    var genres:[mal_idObj]?
    var explicit_genres:[mal_idObj]?
    var themes:[mal_idObj]?
    var demographics:[mal_idObj]?
}

struct mangaData:Codable {
    var mal_id:Int?
    var url:String?
    var imagesObj:imagesObj?
    var title:String?
    var title_english:String?
    var title_japanese:String?
    var title_synonyms:[String]?
    var type:mangaType?
    var chapters:Int?
    var volumes:Int?
    var status:publishingStatus?
    var publishing:Bool?
    var published:publishedObj?
    var score:Float?
    var scored_by:Int?
    var rank:Int?
    var popularity:Int?
    var members:Int?
    var favorites:Int?
    var synopsis:String?
    var background:String?
    var authors:[mal_idObj]?
    var serializations:[mal_idObj]?
    var genres:[mal_idObj]?
    var explicit_genres:[mal_idObj]?
    var themes:[mal_idObj]?
    var demographics:[mal_idObj]?
}

struct animeInfo:Codable {
    
    var animeArr:[animeData]?
    
    var pagination:paginationObj?
    
    enum CodingKeys: String, CodingKey {
        case animeArr = "data"
        case pagination = "pagination"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decodeIfPresent(paginationObj.self, forKey: .pagination)
        animeArr = try container.decodeIfPresent([animeData].self, forKey: .animeArr)
        animeArr!.sort{$0.rank! < $1.rank!}
    }
}

struct mangaInfo:Codable {
    
    var mangaArr:[mangaData]?
    
    var pagination:paginationObj?
    
    enum CodingKeys: String, CodingKey {
        case mangaArr = "data"
        case pagination = "pagination"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decodeIfPresent(paginationObj.self, forKey: .pagination)
        mangaArr = try container.decodeIfPresent([mangaData].self, forKey: .mangaArr)
        mangaArr!.sort{$0.rank! < $1.rank!}
    }
}
