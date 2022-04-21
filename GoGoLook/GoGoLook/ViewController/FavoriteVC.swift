//
//  FavoriteVC.swift
//  Gogolook
//
//  Created by Claud on 2022/4/21.
//

import UIKit

class FavoriteVC: UIViewController {
    
    private var anime:animeInfo? = UserDefaults.standard.value(forKey: UserDefaultKeyName.anime.rawValue) as? animeInfo
    
    private var manga:mangaInfo? = UserDefaults.standard.value(forKey: UserDefaultKeyName.manga.rawValue) as? mangaInfo
    
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
        
        if section == 0, let animeCount = anime?.animeArr?.count {
            count = animeCount
        }
        
        if section == 1, let mangaCount = anime?.animeArr?.count {
            count = mangaCount
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let row = indexPath.row
        let section = indexPath.section
        
        if let info = anime?.animeArr?[row], section == 0 {
            cell.anime = info
        }
        
        if let info = manga?.mangaArr?[row], section == 1 {
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
        
        if let info = anime?.animeArr?[row], section == 0 {
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: false)
                }
            }
        }
        
        if let info = manga?.mangaArr?[row], section == 1 {
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: false)
                }
            }
        }
    }
}

