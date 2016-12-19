//
//  ProtobufRequest.swift
//  Client
//
//  Created by Yusuke Kita on 12/18/16.
//  Copyright © 2016 Yusuke Kita. All rights reserved.
//

import Foundation
import APIKit
import SwiftProtobuf

protocol ProtobufRequest: Request {
}

extension ProtobufRequest {
    var baseURL: URL {
        return URL(string: "http://localhost:8090")!
    }
    
    var dataParser: DataParser {
        return ProtobufDataParser()
    }
}

struct GetToken: ProtobufRequest {
    typealias Response = GetTokenResponse
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/token"
    }
}

struct PostToken: ProtobufRequest {
    typealias Response = PostTokenResponse
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/v1/token"
    }
    
    var bodyParameters: BodyParameters? {
        var token = Token()
        token.accessToken = "old token"
        
        var data = PostTokenRequest()
        data.accessToken = token.accessToken
        
        return ProtobufBodyParameters(protobufObject: try! data.serializeProtobuf())
    }
}

struct ErrorRequest: ProtobufRequest {
    typealias Response = GetTokenResponse
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return "/v1/error"
    }
}

extension ProtobufRequest where Response: SwiftProtobuf.Message {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        
        return try Response(protobuf: data)
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard 200..<300 ~= urlResponse.statusCode else {
            guard let data = object as? Data else {
                throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
            }
            
            let error = try NetworkError(protobuf: data)
            throw ResponseError.unexpectedObject(error)
        }
        return object
    }
}
