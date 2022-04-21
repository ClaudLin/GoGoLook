//
//  ViewController.swift
//  GoGoLook
//
//  Created by 林書郁 on 2022/4/22.
//

import UIKit

class ViewController: UIViewController {
    
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
    
    private func getData(){
        alamofire(urlStr: "\(CommonURL.sharedInstance.Domain)\(CommonURL.sharedInstance.anime)") { [self] data in
            guard let data = data else{
                return
            }
            
            do {
                anime = try JSONDecoder().decode(animeInfo.self, from:data)
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
            }catch{
                print(error)
            }
        } errorHandler: { e in
            print(e.localizedDescription)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
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

extension ViewController: UITableViewDelegate {
    
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
