import Kitura
import SwiftProtobuf
import Foundation

private let router = Router()

router.get("/v1/token") { request, response, next in
    var token = Token()
    token.accessToken = "my token"
    
    var data = GetTokenResponse()
    data.token = token
    
    response.send(data: try data.serializeProtobuf())
    
    next()
}

router.post("/v1/token") { request, response, next in
    var body = Data()
    
    guard let bytes = try? request.read(into: &body),
        let token = try? PostTokenRequest(protobuf: body) else {
        return
    }
    
    guard token.accessToken.characters.count > 0 else {
        var error = NetworkError()
        error.code = .badRequest
        error.message = "invalid access token"
        
        response.status(.badRequest).send(data: try error.serializeProtobuf())
        
        next()
        return
    }
    
    var newToken = Token()
    newToken.accessToken = "new token"
    
    var data = PostTokenResponse()
    data.token = newToken
    
    response.status(.OK).send(data: try data.serializeProtobuf())
    
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()

