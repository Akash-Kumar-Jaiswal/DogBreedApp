//
//  UserModel.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import Foundation


struct MesssageModel: Codable {
    var message = [String: [String]]()
    var messageImage = [String: String]()
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
    }
}

struct BreedImageModel: Codable {
    var message: String
    var status : String
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
        case status = "status"
    }
}

struct AllBreedImageModel: Codable {
    var message: [String]
    var status : String
    
    enum CodingKeys: String, CodingKey{
        case message = "message"
        case status = "status"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
