//
//  FavoriteModel.swift
//  Gogolook
//
//  Created by Claud on 2022/4/20.
//

import UIKit

class FavoriteModel {
    
    static let shared = FavoriteModel()
    
    private var favoriteAnimeArr:[animeData] = {
        if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.anime.rawValue) as? Data {
            let arr = try? PropertyListDecoder().decode(Array<animeData>.self, from: data)
            return arr ?? []
        }
        return []
    }()
    
    {
        willSet{
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: UserDefaultKeyName.anime.rawValue)
        }
    }
    
    private var favoriteMangaArr:[mangaData] = {
        if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.manga.rawValue) as? Data {
            let arr = try? PropertyListDecoder().decode(Array<mangaData>.self, from: data)
            return arr ?? []
        }
        return []
    }()
    
    {
        willSet{
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: UserDefaultKeyName.manga.rawValue)
        }
    }
    
    func addAnimeFavorite(newAnimeData:animeData){
        var arr = favoriteAnimeArr
        arr.append(newAnimeData)
        var uniqueSet = Set<Int>()
        arr = arr.filter { data in
            uniqueSet.insert(data.mal_id ?? 0).inserted
        }
        arr.sort{$0.rank! < $1.rank!}
        favoriteAnimeArr = arr
    }
    
    func addMangaFavorite(newMangaData:mangaData){
        var arr = favoriteMangaArr
        arr.append(newMangaData)
        var uniqueSet = Set<Int>()
        arr = arr.filter { data in
            uniqueSet.insert(data.mal_id ?? 0).inserted
        }
        arr.sort{$0.rank! < $1.rank!}
        favoriteMangaArr = arr
    }
    
    func removeAnimeFavorite(targetAnimeData:animeData){
        var arr = favoriteAnimeArr
        arr = arr.filter { info in
            info.mal_id != targetAnimeData.mal_id
        }
        arr.sort{$0.rank! < $1.rank!}
        favoriteAnimeArr = arr
    }
    
    func removeMangaFavorite(targetMangaData:mangaData){
        var arr = favoriteMangaArr
        arr = arr.filter { info in
            info.mal_id != targetMangaData.mal_id
        }
        arr.sort{$0.rank! < $1.rank!}
        favoriteMangaArr = arr
    }
    
    
    
}
