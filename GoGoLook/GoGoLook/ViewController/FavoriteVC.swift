//
//  FavoriteVC.swift
//  Gogolook
//
//  Created by Claud on 2022/4/21.
//

import UIKit

class FavoriteVC: UIViewController {
        
    private var anime:[animeData] = {
        if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.anime.rawValue) as? Data {
            let arr = try? PropertyListDecoder().decode(Array<animeData>.self, from: data)
            return arr ?? []
        }
        return []
    }()

    
//    private var manga:[mangaData] = UserDefaults.standard.value(forKey: UserDefaultKeyName.manga.rawValue) as? mangaInfo
    
    private var manga:[mangaData] = {
        if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.manga.rawValue) as? Data {
            let arr = try? PropertyListDecoder().decode(Array<mangaData>.self, from: data)
            return arr ?? []
        }
        return []
    }()
    
    private var tableview:UITableView = {
        let tableview = UITableView()
        tableview.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIInit()
    }
    
    private func reloadTableView(){
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

}

extension FavoriteVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        
        if section == 0 {
            count = anime.count
        }
        
        if section == 1 {
            count = manga.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            let info = anime[row]
            cell.anime = info
        }
        
        if section == 1 {
            let info = manga[row]
            cell.manga = info
        }
        
        return cell
    }
    
    
}

extension FavoriteVC: UITableViewDelegate {
    
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
            let info = anime[row]
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: false)
                }
            }
        }
        
        if section == 1 {
            let info = manga[row]
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: false)
                }
            }
        }
    }
}

