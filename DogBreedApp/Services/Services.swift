//
//  Services.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import Foundation


class Services {
    
    static let shared = Services()
    
    // MARK: - Get users list
    func breedList(apiUrl: String, action: @escaping (ReqStatus, MesssageModel?, Error?) -> Void) {
        
        action(ReqStatus.START, nil, nil)
        let mJson: [String: String] = [:]
        let urlReq = getUrlRequest(mUrl: apiUrl, mMethod: ReqMethods.GET, json: mJson)
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard let data = data, error == nil else {
                action(ReqStatus.ERROR, nil, error)
                return
            }
            do {
                let responseModel = try JSONDecoder().decode(MesssageModel.self, from: data)
                NSLog("USER: \(responseModel)", "")
                action(ReqStatus.SUCCESS, responseModel, nil)
            } catch let err {
                print(err)
                action(ReqStatus.ERROR, nil, err)
            }
        }.resume()
        
    }
    
    func setBreedImage(apiUrl: String, action: @escaping (ReqStatus, BreedImageModel?, Error?) -> Void) {
        
        action(ReqStatus.START, nil, nil)
        let mJson: [String: String] = [:]
        let urlReq = getUrlRequest(mUrl: apiUrl, mMethod: ReqMethods.GET, json: mJson)
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard let data = data, error == nil else {
                action(ReqStatus.ERROR, nil, error)
                return
            }
            do {
                let responseModel = try JSONDecoder().decode(BreedImageModel.self, from: data)
                NSLog("USER: \(responseModel)", "")
                action(ReqStatus.SUCCESS, responseModel, nil)
            } catch let err {
                print(err)
                action(ReqStatus.ERROR, nil, err)
            }
        }.resume()
        
    }
    
    func getallImgaesOfBreeds(apiUrl: String, action: @escaping (ReqStatus, AllBreedImageModel?, Error?) -> Void) {
        
        action(ReqStatus.START, nil, nil)
        let mJson: [String: String] = [:]
        let urlReq = getUrlRequest(mUrl: apiUrl, mMethod: ReqMethods.GET, json: mJson)
        URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
            guard let data = data, error == nil else {
                action(ReqStatus.ERROR, nil, error)
                return
            }
            do {
                let responseModel = try JSONDecoder().decode(AllBreedImageModel.self, from: data)
                NSLog("USER: \(responseModel)", "")
                action(ReqStatus.SUCCESS, responseModel, nil)
            } catch let err {
                print(err)
                action(ReqStatus.ERROR, nil, err)
            }
        }.resume()
        
    }
    
}
