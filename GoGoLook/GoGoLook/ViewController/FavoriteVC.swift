//
//  FavoriteVC.swift
//  Gogolook
//
//  Created by Claud on 2022/4/21.
//

import UIKit

class FavoriteVC: UIViewController {
        
    private var animeDataArr:[animeData] = {
        if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.anime.rawValue) as? Data {
            let arr = try? PropertyListDecoder().decode(Array<animeData>.self, from: data)
            return arr ?? []
        }
        return []
    }()

    private var mangaDataArr:[mangaData] = {
        if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.manga.rawValue) as? Data {
            let arr = try? PropertyListDecoder().decode(Array<mangaData>.self, from: data)
            return arr ?? []
        }
        return []
    }()
    
    private var tableview:UITableView = {
        let tableview = UITableView()
        tableview.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
        return tableview
    }()
    
    private var animeLimit = 5
    
    private var mangaLimit = 5
    
    private var animeDataOfTableView:[animeData] = []
    
    private var mangaDataOfTableView:[mangaData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Favorite"
        setData()
        // Do any additional setup after loading the view.
    }
    
    private func setData(){
        var animeIndex = 0
        while animeIndex < animeLimit {
            animeDataOfTableView.append(animeDataArr[animeIndex])
            animeIndex = animeIndex + 1
            if animeIndex + 1 > animeDataArr.count {
                break
            }
        }
        var mangaIndex = 0
        while mangaIndex < animeLimit {
            mangaDataOfTableView.append(mangaDataArr[mangaIndex])
            mangaIndex = mangaIndex + 1
            if mangaIndex + 1 > mangaDataArr.count {
                break
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIInit()
    }
    
    @objc private func reloadTableView(){
        DispatchQueue.main.async { [self] in
            tableview.reloadData()
        }
    }
    
    private func UIInit(){
        tableview.delegate = self
        tableview.dataSource = self
        view.addSubview(tableview)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        tableview.topAnchor.constraint(equalTo: view.topAnchor, constant: getFrame().minY).isActive = true
        tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableview.widthAnchor.constraint(equalToConstant: getFrame().width).isActive = true
        tableview.heightAnchor.constraint(equalToConstant: getFrame().height).isActive = true
    }
    
    private func Alert( title:String? ,message:String? ,ActionTitle:String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: ActionTitle, style: .default, handler: nil)
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }

}

extension FavoriteVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        
        if section == 0 {
            count = animeDataOfTableView.count
        }
        
        if section == 1 {
            count = mangaDataOfTableView.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            let info = animeDataOfTableView[row]
            cell.anime = info
        }
        
        if section == 1 {
            let info = mangaDataOfTableView[row]
            cell.manga = info
        }
        
        return cell
    }
    
    
}

extension FavoriteVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == animeDataOfTableView.count - 1 {
                if animeDataOfTableView.count < animeDataArr.count {
                    var index = animeDataOfTableView.count
                    animeLimit = index + 5
                    while index < animeLimit {
                        animeDataOfTableView.append(animeDataArr[index])
                        index = index + 1
                    }
                    self.perform(#selector(reloadTableView), with: nil, afterDelay: 1.0)
                }
            }
        }
        if section == 1 {
            if row == mangaDataOfTableView.count - 1 {
                if mangaDataOfTableView.count < mangaDataArr.count {
                    var index = mangaDataOfTableView.count
                    mangaLimit = index + 5
                    while index < mangaLimit {
                        mangaDataOfTableView.append(mangaDataArr[index])
                        index = index + 1
                    }
                    self.perform(#selector(reloadTableView), with: nil, afterDelay: 1.0)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var result = ""
        
        if section == 0 {
            result = "anime"
        }
        
        if section == 1 {
            result = "manga"
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            let info = animeDataOfTableView[row]
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: false)
                }else{
                    Alert(title: "URL error", message: nil, ActionTitle: "OK")
                }
            }
        }
        
        if section == 1 {
            let info = mangaDataOfTableView[row]
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: false)
                }else{
                    Alert(title: "URL error", message: nil, ActionTitle: "OK")
                }
            }
        }
    }
}

