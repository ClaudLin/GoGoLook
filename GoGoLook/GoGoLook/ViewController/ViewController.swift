//
//  ViewController.swift
//  GoGoLook
//
//  Created by 林書郁 on 2022/4/22.
//

import UIKit

class ViewController: UIViewController {
    
    enum cellType {
        case anime
        case manga
    }
    
    private var btn:UIButton = {
        let btn = UIButton()
        btn.setTitle("My favorite", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        return btn
    }()
    
    private var tableview:UITableView = {
        let tableview = UITableView()
        tableview.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        return tableview
    }()
    
    private var anime:animeInfo? = nil
    {
        didSet{
            reloadTableView()
        }
    }
    
    private var manga:mangaInfo? = nil
    {
        didSet{
            reloadTableView()
        }
    }
    
    private var animeLimit = 5
    
    private var mangaLimit = 5
    
    private var animeDataArr:[animeData] = []
    
    private var mangaDataArr:[mangaData] = []
    
    @objc private func btnAction( btn:UIButton){
        let VC = FavoriteVC()
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List"
        getData()
        // Do any additional setup after loading the view.
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
        view.backgroundColor = .white
        view.addSubview(btn)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.topAnchor.constraint(equalTo: view.topAnchor, constant: getFrame().minY).isActive = true
        btn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true

        tableview.delegate = self
        tableview.dataSource = self
        view.addSubview(tableview)
                
        tableview.translatesAutoresizingMaskIntoConstraints = false

        tableview.topAnchor.constraint(equalTo: btn.bottomAnchor).isActive = true
        tableview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableview.widthAnchor.constraint(equalToConstant: getFrame().width).isActive = true
        tableview.heightAnchor.constraint(equalToConstant: getFrame().height - 50).isActive = true
    }
    
    private func getData(){
        alamofire(urlStr: "\(CommonURL.sharedInstance.Domain)\(CommonURL.sharedInstance.anime)") { [self] data in
            guard let data = data else{
                return
            }
            
            do {
                anime = try JSONDecoder().decode(animeInfo.self, from:data)
                if let animeArr = anime?.animeArr {
                    var index = 0
                    while index < animeLimit {
                        animeDataArr.append(animeArr[index])
                        index = index + 1
                    }
                }
            }catch{
                print(error)
            }
        } errorHandler: { e in
            print(e.localizedDescription)
        }
        
        alamofire(urlStr: "\(CommonURL.sharedInstance.Domain)\(CommonURL.sharedInstance.manga)") { [self] data in
            guard let data = data else{
                return
            }
            
            do {
                manga = try JSONDecoder().decode(mangaInfo.self, from:data)
                if let mangaArr = manga?.mangaArr {
                    var index = 0
                    while index < mangaLimit {
                        mangaDataArr.append(mangaArr[index])
                        index = index + 1
                    }
                }
            }catch{
                print(error)
            }
        } errorHandler: { e in
            print(e.localizedDescription)
        }
    }
    
    private func checkIsFavorite(type:cellType ,mal_id:Int?) -> Bool {
        var result = false
        switch type{
            case.anime:
                let info:[animeData] = {
                    if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.anime.rawValue) as? Data {
                        let arr = try? PropertyListDecoder().decode(Array<animeData>.self, from: data)
                        return arr ?? []
                    }
                    return []
                }()
                for i in info {
                    if i.mal_id == mal_id {
                        result = true
                        break
                    }
                }
            case.manga:
                let info:[mangaData] = {
                    if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.manga.rawValue) as? Data {
                        let arr = try? PropertyListDecoder().decode(Array<mangaData>.self, from: data)
                        return arr ?? []
                    }
                    return []
                }()
                for i in info {
                    if i.mal_id == mal_id {
                        result = true
                        break
                    }
                }
        }
        return result
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        
        if section == 0 {
            count = animeDataArr.count
        }
        
        if section == 1 {
            count = mangaDataArr.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let row = indexPath.row
        let section = indexPath.section
        
        if let info = anime?.animeArr?[row], section == 0 {
            cell.anime = info
            cell.isFavorite = checkIsFavorite(type: .anime, mal_id: info.mal_id)
        }
        
        if let info = manga?.mangaArr?[row], section == 1 {
            cell.manga = info
            cell.isFavorite = checkIsFavorite(type: .manga, mal_id: info.mal_id)
        }
        
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if let animeArr = anime?.animeArr {
                if row == animeDataArr.count - 1 {
                    if animeDataArr.count < animeArr.count {
                        var index = animeDataArr.count
                        animeLimit = index + 5
                        while index < animeLimit {
                            animeDataArr.append(animeArr[index])
                            index = index + 1
                        }
                        self.perform(#selector(reloadTableView), with: nil, afterDelay: 1.0)
                    }
                }
            }
        }
        
        if section == 1 {
            if let mangaArr = manga?.mangaArr {
                if row == mangaDataArr.count - 1 {
                    if mangaDataArr.count < mangaArr.count {
                        var index = mangaDataArr.count
                        mangaLimit = index + 5
                        while index < mangaLimit {
                            mangaDataArr.append(mangaArr[index])
                            index = index + 1
                        }
                        self.perform(#selector(reloadTableView), with: nil, afterDelay: 1.0)
                    }
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
        
        if let info = anime?.animeArr?[row], section == 0 {
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
        
        if let info = manga?.mangaArr?[row], section == 1 {
            if let urlStr = info.url, info.url != "" {
                if let url = URL(string: urlStr){
                    let VC = WebviewVC(url: url)
                    navigationController?.pushViewController(VC, animated: true)
                }
            }
        }
    }
}
