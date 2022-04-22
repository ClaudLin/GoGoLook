//
//  CustomCell.swift
//  Gogolook
//
//  Created by 林書郁 on 2022/4/20.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var isFavorite = false
    {
        willSet {
            if newValue {
                favoriteBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }else{
                favoriteBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
        }
    }
    
    private var currentType:type? = nil
    
    private enum type {
        case anime
        case manga
    }
    
    var anime:animeData? = nil
    {
        didSet {
            if let info = oldValue {
                currentType = .anime
                titleLabel.text = "title:\(info.title ?? "")"
                rankLabel.text = "rank:\(String(describing: info.rank!))"
                startDateLabel.text = "start data:\(info.aired?.from ?? "")"
                endDateLabel.text = "end data:\(info.aired?.to ?? "")"
                imageURL = info.imagesObj?.jpgObj?.image_url ?? ""
                isFavorite = checkIsFavorite()
            }
        }
    }
    
    var manga:mangaData? = nil
    {
        didSet {
            if let info = oldValue {
                currentType = .manga
                titleLabel.text = "title:\(info.title ?? "")"
                rankLabel.text = "rank:\(String(describing: info.rank!))"
                startDateLabel.text = "start data:\(info.published?.from ?? "")"
                endDateLabel.text = "end data:\(info.published?.to ?? "")"
                imageURL = info.imagesObj?.jpgObj?.image_url ?? ""
                isFavorite = checkIsFavorite()
            }
        }
    }
    
    private var favoriteBtn:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()

    private var imageview:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "multiply")
        return imageview
    }()
    
    private let leftStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let rightStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private var titleLabel:UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        return label
    }()
    
    private var rankLabel:UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        return label
    }()
    
    private var startDateLabel:UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        return label
    }()
    
    private var endDateLabel:UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        return label
    }()
    
    private var imageURL:String = ""
    {
        willSet{
            if newValue != "" {
                alamofire(urlStr: newValue) { data in
                    DispatchQueue.main.async { [self] in
                        guard let data = data else { return }
                        imageview.image = UIImage(data: data)
                    }
                } errorHandler: { err in
                    print(err.localizedDescription)
                }

            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIInit()
        addGesture()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func UIInit(){
        self.selectionStyle = .none
        addSubview(leftStackView)
        
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        
        leftStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftStackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        leftStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        leftStackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        let widthSize:CGFloat = self.frame.width/1.2
        let heightSize:CGFloat = 30
        
        titleLabel.widthAnchor.constraint(equalToConstant: widthSize).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: heightSize).isActive = true
        
        rankLabel.widthAnchor.constraint(equalToConstant: widthSize).isActive = true
        rankLabel.heightAnchor.constraint(equalToConstant: heightSize).isActive = true
        
        startDateLabel.widthAnchor.constraint(equalToConstant: widthSize).isActive = true
        startDateLabel.heightAnchor.constraint(equalToConstant: heightSize).isActive = true
        
        endDateLabel.widthAnchor.constraint(equalToConstant: widthSize).isActive = true
        endDateLabel.heightAnchor.constraint(equalToConstant: heightSize).isActive = true
        
        
        leftStackView.addArrangedSubview(titleLabel)
        leftStackView.addArrangedSubview(rankLabel)
        leftStackView.addArrangedSubview(startDateLabel)
        leftStackView.addArrangedSubview(endDateLabel)
        
        addSubview(rightStackView)
        
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        
        rightStackView.leadingAnchor.constraint(equalTo: leftStackView.trailingAnchor).isActive = true
        rightStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rightStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3).isActive = true
        rightStackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        imageview.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        favoriteBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        favoriteBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        rightStackView.addArrangedSubview(imageview)
        rightStackView.addArrangedSubview(favoriteBtn)
        
        
    }
    
    private func addGesture(){
        let singleFinger = UITapGestureRecognizer( target:self, action:#selector(singleTap(recognizer:)))
        singleFinger.numberOfTapsRequired = 2
        self.addGestureRecognizer(singleFinger)
    }
    
    @objc private func singleTap(recognizer:UITapGestureRecognizer){
        isFavorite = !isFavorite
        switch currentType {
        case .manga:
            if let manga = manga {
                if isFavorite {
                    FavoriteModel.shared.addMangaFavorite(newMangaData: manga)
                }else{
                    FavoriteModel.shared.removeMangaFavorite(targetMangaData: manga)
                }
            }
        case .anime:
            if let anime = anime {
                if isFavorite {
                    FavoriteModel.shared.addAnimeFavorite(newAnimeData: anime)
                }else{
                    FavoriteModel.shared.removeAnimeFavorite(targetAnimeData: anime)
                }
            }
        case .none:
            break
        }
    }
    
    private func checkIsFavorite() -> Bool {
        var result = false
        switch currentType{
            case.anime:
                let info:[animeData] = {
                    if let data = UserDefaults.standard.value(forKey:UserDefaultKeyName.anime.rawValue) as? Data {
                        let arr = try? PropertyListDecoder().decode(Array<animeData>.self, from: data)
                        return arr ?? []
                    }
                    return []
                }()
                for i in info {
                    if i.mal_id == anime?.mal_id {
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
                    if i.mal_id == anime?.mal_id {
                        result = true
                        break
                    }
                }
            case .none:
                break
        }
        
        return result
    }

}
