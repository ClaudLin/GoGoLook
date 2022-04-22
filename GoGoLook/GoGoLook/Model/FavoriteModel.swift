//
//  FavoriteModel.swift
//  Gogolook
//
//  Created by Claud on 2022/4/20.
//

import UIKit

class FavoriteModel {
    
    static let shared = FavoriteModel()
    
    private var favoriteAnimeArr = UserDefaults.standard.value(forKey: UserDefaultKeyName.anime.rawValue) as? [animeData] ?? []
    {
        willSet{
            print(newValue)
        }
    }
    
    private var favoriteMangaArr = UserDefaults.standard.value(forKey: UserDefaultKeyName.manga.rawValue) as? [mangaData] ?? []
    

    func addAnimeFavorite(newAnimeData:animeData){
        favoriteAnimeArr.append(newAnimeData)
        var uniqueSet = Set<Int>()
        favoriteAnimeArr = favoriteAnimeArr.filter { data in
            uniqueSet.insert(data.mal_id ?? 0).inserted
        }
        favoriteAnimeArr.sort{$0.rank! < $1.rank!}
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteAnimeArr), forKey: UserDefaultKeyName.anime.rawValue)
    }
    
    func addMangaFavorite(newMangaData:mangaData){
        favoriteMangaArr.append(newMangaData)
        var uniqueSet = Set<Int>()
        favoriteMangaArr = favoriteMangaArr.filter { data in
            uniqueSet.insert(data.mal_id ?? 0).inserted
        }
        favoriteMangaArr.sort{$0.rank! < $1.rank!}
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteMangaArr), forKey: UserDefaultKeyName.manga.rawValue)
    }
    
    func removeAnimeFavorite(targetAnimeData:animeData){
        favoriteAnimeArr = favoriteAnimeArr.filter { info in
            info.mal_id != targetAnimeData.mal_id
        }
        favoriteAnimeArr.sort{$0.rank! < $1.rank!}
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteAnimeArr), forKey: UserDefaultKeyName.anime.rawValue)
    }
    
    func removeMangaFavorite(targetMangaData:mangaData){
        favoriteMangaArr = favoriteMangaArr.filter { info in
            info.mal_id != targetMangaData.mal_id
        }
        favoriteMangaArr.sort{$0.rank! < $1.rank!}
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favoriteMangaArr), forKey: UserDefaultKeyName.manga.rawValue)
    }
    
    
    
}
