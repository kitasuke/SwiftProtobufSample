import Kitura
import SwiftProtobuf

private let router = Router()
private var token = Token()

router.get("/v1/token") { request, response, next in
    token.accessToken = "my token"
    
    var data = GetTokenResponse()
    data.token = token
    
    response.send(data: try data.serializeProtobuf())
    
    next()
}

router.post("/v1/token") { request, response, next in
    token.accessToken = "new token"
    
    var data = PostTokenResponse()
    data.token = token
    
    response.status(.OK).send(data: try data.serializeProtobuf())
    
    next()
}

router.get("/v1/error") { request, response, next in
    var error = NetworkError()
    error.code = .notFound
    error.message = "error message"
    
    response.status(.notFound).send(data: try error.serializeProtobuf())
    
    next()
}

Kitura.addHTTPServer(onPort: 8090, with: router)

Kitura.run()

