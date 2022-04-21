//
//  AlamofireManager.swift
//  Marais
//
//
//

import Foundation
import Alamofire

private let ImageCompressionQuality = 0.7

private let headers:HTTPHeaders =
[
"Content-Type": "application/x-www-form-urlencoded"
]

public func alamofire(urlStr:String ,completion: @escaping((Data?) -> Void) ,errorHandler: @escaping(Error) -> Void){
    AF.request(urlStr).response(completionHandler: { response in
        switch response.result {
        case .success(let data):
            completion(data)
        case .failure(let e):
            print(e)
            errorHandler(e)
        }
    })
}

public func alamofireToJson(urlStr:String ,completion: @escaping(([String : Any]?) -> Void) ,errorHandler: @escaping(Error) -> Void){
    AF.request(urlStr).responseJSON(completionHandler: { response in
        switch response.result {
        case .success(let dic):
            completion(dic as? [String : Any])
        case .failure(let e):
            print(e)
            errorHandler(e)
        }
    })
}

public func alamofirePostJson(postURL:String ,param:[String:String] ,completion: @escaping([String:Any]?) -> Void  ,errorHandler: @escaping(Error) -> Void){
    

    _ = AF.request(postURL, method: .post ,parameters: param,headers: headers).responseJSON(completionHandler: { response in
        switch response.result {
        case .success(let dic):
            completion(dic as? [String : Any])
        case .failure(let e):
            print(e)
            errorHandler(e)
        }
    })
}

public func alamofirePost(postURL:String ,param:[String:String] ,completion: @escaping(Data?) -> Void ,errorHandler: @escaping(Error) -> Void){
    
    _ = AF.request(postURL, method: .post ,parameters: param,headers: headers).response(completionHandler: { response in
        switch response.result {
        case .success(let data):
            completion(data)
        case .failure(let e):
            print(e)
            errorHandler(e)
        }
    })
    
}


public func alamofireUploadPost(postURL:String ,param:[String:Any]?, imageParam:[String:UIImage]? ,completion: @escaping(String) -> Void ,errorHandler: @escaping(Error) -> Void){
    AF.upload(multipartFormData: {(multipartFormData) in
        
        if let dic = param {
            for (key ,value) in dic {
                
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                
                if let temp = value as? Data {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
            
            }
        }
        
        if let imageDic = imageParam {
            for (imagekey ,img) in imageDic {
                guard let imgData = img.jpegData(compressionQuality: ImageCompressionQuality) else { return }
                multipartFormData.append(imgData, withName:imagekey ,fileName:"image.jpeg" ,mimeType: "image/jpeg")
            }
        }
        
    } ,to: postURL, usingThreshold: UInt64.init() ,method: .post).responseString(completionHandler: { response in
        
        switch response.result {
        case .success(let str):
            print(str)
            completion(str)
        case .failure(let e):
            print(e)
            errorHandler(e)
        }
    })

}
