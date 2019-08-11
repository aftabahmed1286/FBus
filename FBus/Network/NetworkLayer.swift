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
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error -> Void in
            guard let responseData = data,
                error == nil  else {
                    completionHandler(nil, error)
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            completionHandler(responseData, nil)
        }
        task.resume()
        
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
        
        let task = URLSession.shared.downloadTask(with: request) {url, response, error -> Void in
            guard let fileUrl = url,
                error == nil  else {
                    completionHandler(nil, response, error)
                    print(error?.localizedDescription ?? "Response Error")
                    return
            }
            completionHandler(fileUrl, response, nil)
        }
        task.resume()
    }
    
}
