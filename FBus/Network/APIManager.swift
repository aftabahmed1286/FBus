//
//  APIManager.swift
//
//  Created by Aftab Ahmed on 7/5/19.
//  Copyright © 2019 FAMCO. All rights reserved.
//

import Foundation

public enum DataSourceServiceName: String {
    case stationTimetable = "stationTimetable"
}

class APIManager {
    
    /**********************************************
     * CONSTANTS
     **********************************************/
    
    static let shared: APIManager = APIManager()
    
    var baseURL: String {
        guard let host = Bundle.main.infoDictionary?["DataSourceHost"] as? [String: Any],
            let base = host["baseUrl"] as? String else {
            return ""
        }
        return base
    }
    
    /**********************************************
     * END POINTS
     **********************************************/
    
    var stationTimetableEndpoint: String {
        guard let paths = Bundle.main.infoDictionary?["DataSourcePath"] as? [String: Any],
            let stationTimetable = paths["stationTimetable"] as? String else {
            return ""
        }
        return stationTimetable
    }
    
    /**********************************************
     * API REQUEST RESPONSES
     **********************************************/
    
    func fetchStationTimetableResponseModel(stationId: String, completion: @escaping (
        _ stationTimetableModel: StationTimetableModel?,
        _ error: Error?) -> Void
        ) {
        
        var urlString = APIManager.shared.baseURL +
            APIManager.shared.stationTimetableEndpoint
        urlString = urlString.replacingOccurrences(of: "{station_id}", with: stationId)
            
        print(urlString)
        
        NetworkLayer.shared.requestData(urlString: urlString,
                                        method: .GET,
                                        completionHandler: { (data, error) in
                                            guard let responseData = data,
                                                error == nil  else {
                                                    print(error?.localizedDescription ?? "Response Error")
                                                    completion(nil, error)
                                                    return
                                            }
                                            
                                            let dataModel = self.parseStationtimeTableData(response: responseData)
                                            completion(dataModel, nil)
        })
    }
    
    func parseStationtimeTableData(response: Data) -> StationTimetableModel? {
        do {
            let stationTimetableModel = try JSONDecoder().decode(StationTimetableModel.self, from: response)
            return stationTimetableModel
        } catch let parsingError {
            print("Error : \(parsingError)")
            return nil
        }
    }
    
    func downloadImage(url: URL) {
        NetworkLayer.shared.requestDownload(urlString: url.absoluteString,
                                            method: .GET,
                                            completionHandler: {(url, urlResponse ,error) in
                                                
                                                let imagesFolder = self.imagesFolerURL()
                                                
                                                guard let localURL = url else {
                                                    print("Download Error: ", error ?? "")
                                                    return
                                                }
                                                
                                                let destPath = imagesFolder.appendingPathComponent(urlResponse?.suggestedFilename ?? localURL.lastPathComponent)
                                                
                                                do {
                                                    try FileManager.default.moveItem(at: localURL, to: destPath)
                                                } catch {
                                                    print(error)
                                                }
                                                
        })
    }
 
    private func imagesFolerURL() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagesFolder = documentDirectory.appendingPathComponent("NYTimesImages")
        return imagesFolder
    }
    
    func createImagesFolder() {
        let imagesFolder = imagesFolerURL()
        if !FileManager.default.fileExists(atPath: imagesFolder.path) {
            do {
                try FileManager.default.createDirectory(at: imagesFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Unable to create a folder")
                return
            }
        } else {
            try? FileManager.default.removeItem(atPath: imagesFolder.path)
            createImagesFolder()
        }
    }
}
