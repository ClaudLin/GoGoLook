//
//  APIService.swift
//  amazingtalker-ios-Claud
//
//  Created by 林書郁 on 2022/3/21.
//

import Foundation

typealias APIResponse = (data: Any?, message: String?)
typealias APIErrorResponse = (type: APIService.ErrorType, description: String?)

class APIService {
    
    private let timeout = 10.0
    
    enum ErrorType: String {
        case connection = "Code003", server = "Code002", wrongData = "Code001"
        case noError = ""
    }
    
    //MARK: - Get
    func getData(_ urlString: String, completion: @escaping (APIResponse)->(), errorHandler: @escaping (APIErrorResponse)->() = {_ in }) {
        guard let request = getRequest(urlString) else {
            assertionFailure()
            return
        }
        URLSession.shared.dataTask(with: request) {data, response, error in
            let result = self.result(from: data, response, error)
            switch result.type {
            case .noError:
                completion((result.json, nil))
            default:
                errorHandler((result.type, result.error))
                
            }
        }.resume()
    }
    
    //MARK: - Post
    func postData(_ urlString: String, body: String, completion: @escaping (APIResponse)->(), errorHandler: @escaping (APIErrorResponse)->() = {_ in }) {
        guard let request = postRequest(urlString, body: body) else {
            assertionFailure()
            return
        }
        URLSession.shared.dataTask(with: request) {data, response, error in
            let result = self.result(from: data, response, error)
            switch result.type {
            case .noError:
                completion((result.json, nil))
            default:
                errorHandler((result.type, result.error))
                
            }
        }.resume()
    }
    
    //MARK: - Actions
    private func getRequest(_ urlString: String) -> URLRequest? {
        guard
            let percentString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: percentString)
        else {
            return nil
        }
        return URLRequest(url: url, timeoutInterval: timeout)
    }
    
    private func postRequest(_ urlString: String, body: String) -> URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: String.Encoding.utf8)
        return request
    }
    
    private func result(from data: Data?, _ response: URLResponse?, _ error: Error?) -> (json: [String: Any]?, type: ErrorType, error: String?, code: String?) {
        if let error = error {
            let description = error.localizedDescription
            return (nil, .connection, description, nil)
        }
        let httpResponse = response as! HTTPURLResponse
        let code = String(httpResponse.statusCode)
        guard let data = data else {
            let header = String(describing: httpResponse.allHeaderFields)
            return (nil, .server, header, code)
        }
        if code == "500" {return (nil, .server, nil, code)}
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            let description = String(data: data, encoding: .utf8)
            return (nil, .wrongData, description, code)
        }
        return (json, .noError, nil, code)
    }
}
