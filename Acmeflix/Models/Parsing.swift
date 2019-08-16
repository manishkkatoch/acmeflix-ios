//
//  Parsing.swift
//  Acmeflix
//
//  Created by Manish Katoch on 04/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation

/**
 Parsing function to decode Data to a Decodable type T
 */
public func parse<T>(type: T.Type, data: Data) -> T? where T : Decodable {
    let decoder = JSONDecoder()
    return try? decoder.decode(type, from: data)
}

/*
 Poor man's decoder for Any reference type.
 */
enum DecodableValueType: Decodable {
    case int(Int)
    case string(String)
    case double(Double)
    case bool(Bool)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.typeMismatch(DecodableValueType.self,
                                             DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
        }
    }
    
    func getValue() -> Any {
        switch self {
        case .int(let iValue): return iValue
        case .double(let dValue): return dValue
        case .bool(let bValue): return bValue
        case .string(let sValue): return sValue
        }
    }
    
    static func from(_ any: Any) -> DecodableValueType  {
        switch any {
        case is String : return DecodableValueType.string(any as! String)
        case is Int : return DecodableValueType.int(any as! Int)
        case is Double : return DecodableValueType.double(any as! Double)
        case is Bool : return DecodableValueType.bool(any as! Bool)
        default: return DecodableValueType.string(String.init(describing: any))
        }
    }
}
