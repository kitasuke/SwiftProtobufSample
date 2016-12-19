import Kitura
import SwiftProtobuf

let router = Router()

router.get("/v1/token") { request, response, next in
    var token = Token()
    token.accessToken = "token"
    
    var data = GetTokenResponse()
    data.token = token
    
    response.send(data: try data.serializeProtobuf())
    
    next()
}

router.post("/v1/token") { request, response, next in
    var token = Token()
    token.accessToken = "new token"
    
    var data = PostTokenResponse()
    data.token = token
    
    response.status(.OK).send(data: try data.serializeProtobuf())
    
    next()
}

router.get("/v1/error") { request, response, next in
    var error = NetworkError()
    error.code = .notFound
    
    response.status(.notFound).send(data: try error.serializeProtobuf())
    
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()

