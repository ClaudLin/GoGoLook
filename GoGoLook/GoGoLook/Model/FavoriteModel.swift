//
//  FavoriteModel.swift
//  Gogolook
//
//  Created by Claud on 2022/4/20.
//

import UIKit

class FavoriteModel {
    
    static let shared = FavoriteModel()
    
    private var favoriteAnimeArr = UserDefaults.standard.value(forKey: UserDefaultKeyName.anime.rawValue) as? animeInfo ?? nil
    {
        willSet {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeyName.anime.rawValue)
        }
    }
    

    private var favoriteMangaArr = UserDefaults.standard.value(forKey: UserDefaultKeyName.manga.rawValue) as? mangaInfo ?? nil
    {
        willSet {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeyName.manga.rawValue)
        }
    }

    func addAnimeFavorite(newAnimeData:animeData){
        var total:[animeData] = favoriteAnimeArr?.animeArr ?? []
        total.append(newAnimeData)
        var uniqueSet = Set<Int>()
        total = total.filter { data in
            uniqueSet.insert(data.mal_id ?? 0).inserted
        }
        total.sort{$0.rank! < $1.rank!}
        favoriteAnimeArr?.animeArr = total
    }
    
    func addMangaFavorite(newMangaData:mangaData){
        var total = favoriteMangaArr?.mangaArr ?? []
        total.append(newMangaData)
        var uniqueSet = Set<Int>()
        total = total.filter { data in
            uniqueSet.insert(data.mal_id ?? 0).inserted
        }
        total.sort{$0.rank! < $1.rank!}
        favoriteMangaArr?.mangaArr = total
    }
    
    
}
