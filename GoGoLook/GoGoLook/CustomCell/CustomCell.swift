//
//  CustomCell.swift
//  Gogolook
//
//  Created by 林書郁 on 2022/4/20.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var isFavorite = false
    
    var anime:animeData? = nil
    {
        willSet {
            if let info = newValue {
                titleLabel.text = "title:\(info.title ?? "")"
                rankLabel.text = "rank:\(String(describing: info.rank!))"
                startDateLabel.text = "start data:\(info.aired?.from ?? "")"
                endDateLabel.text = "end data:\(info.aired?.to ?? "")"
                imageURL = info.imagesObj?.jpgObj?.image_url ?? ""
            }
        }
    }
    
    var manga:mangaData? = nil
    {
        willSet {
            if let info = newValue {
                titleLabel.text = "title:\(info.title ?? "")"
                rankLabel.text = "rank:\(String(describing: info.rank!))"
                startDateLabel.text = "start data:\(info.published?.from ?? "")"
                endDateLabel.text = "end data:\(info.published?.to ?? "")"
                imageURL = info.imagesObj?.jpgObj?.image_url ?? ""
            }
        }
    }

    private var imageview:UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "multiply")
        return imageview
    }()
    
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
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
        addSubview(imageview)
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        
        imageview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7).isActive = true
        stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
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
        
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(rankLabel)
        stackView.addArrangedSubview(startDateLabel)
        stackView.addArrangedSubview(endDateLabel)
    }
    
    private func addGesture(){
        let singleFinger = UITapGestureRecognizer( target:self, action:#selector(singleTap(recognizer:)))
        singleFinger.numberOfTapsRequired = 2
        self.addGestureRecognizer(singleFinger)
    }
    
    @objc private func singleTap(recognizer:UITapGestureRecognizer){
        isFavorite = !isFavorite
        
    }

    
}
