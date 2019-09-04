//
//  NetworkLayer.swift
//
//  Created by Aftab Ahmed on 7/5/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation

class NetworkLayer {
    
    static var shared: NetworkLayer = NetworkLayer()
    
    enum httpMethod: String {
        case GET = "GET"
    }
    
    enum taskType {
        case DATA
        case DOWNLOAD
        case UPLOAD
    }
    
    func requestData(urlString: String,
                     method: httpMethod,
                     completionHandler: @escaping (
        _ data: Data?,
        _ error: Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = [
            "X-Api-Authentication": "intervIEW_TOK3n"
        ]
        
        URLSession.shared.dataTask(with: request){ result in
            switch result {
            case .success( _, let data):
                completionHandler(data, nil)
            case .failure(let err):
                completionHandler(nil, err)
            }
        }.resume()
        
    }
    
    func requestDownload(urlString: String,
                         method: httpMethod,
                         completionHandler: @escaping (
        _ url: URL?,
        _ urlResponse: URLResponse?,
        _ error: Error?) -> Void) {
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = URLSession.shared.downloadTask(with: request) {result in
            switch result {
            case .success( let url, let urlResponse):
                completionHandler(url, urlResponse, nil)
            case .failure(let err):
                completionHandler(nil, nil, err)
            }
        }
        task.resume()
    }
    
}

extension URLSession {
    
    func dataTask(with request: URLRequest, result: @escaping ( Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            result(.success((response, data)))
        }
    }
    
    func downloadTask(with request: URLRequest, result: @escaping ( Result<(URL, URLResponse), Error>) -> Void) -> URLSessionDownloadTask {
     
        return downloadTask(with: request) {
            (url, response, error) -> Void in
            if let error = error {
                result(.failure(error))
                return
            }
            
            guard let response = response, let url = url else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            
            result(.success((url, response)))
        }
    }
    
}
