//
//  RequestHelper.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import Foundation

enum ReqStatus {
    case START
    case SUCCESS
    case ERROR
}

struct ReqMethods {
    static let GET     = "GET"
    static let POST    = "POST"
    static let PUT     = "PUT"
    static let DELETE  = "DELETE"
    static let PATCH   = "PATCH"
}


public func getUrlRequest(mUrl: String, mMethod: String, json: [String: Any]) -> URLRequest {
    
    let url = URL(string: mUrl.replacingOccurrences(of: " ", with: "%20"))
    
    var urlReq = URLRequest.init(url: url!)
    urlReq.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    
    
    urlReq.httpMethod = mMethod
    urlReq.timeoutInterval = 120
    if !json.isEmpty {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        urlReq.httpBody = jsonData
    }
    return urlReq
    
}

