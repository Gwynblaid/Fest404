// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

import Foundation
import ObjectMapper

struct PhotosResponse: ImmutableMappable {
    var photos: [InstagramPhotoData]
    
    init(map: Map) throws {
        photos = try map.value("data")
    }
}

class ModelResourceFactory {
    
    func tokenResource(clientID: String, clientSecret: String, grantType: String = "authorization_code", redirectURI: String, code: String) -> Resource<TokenData> {
        guard let url = URL(string: "https://api.instagram.com/oauth/access_token") else {
            fatalError("Can't create URL")
        }
        let params = [
            "client_id" : clientID,
            "client_secret" : clientSecret,
            "grant_type" : grantType,
            "redirect_uri" : redirectURI,
            "code" : code,
        ]
        let method = HttpMethod<Data>.post(params.getString.data(using: .utf8)!)
        return Resource<TokenData>(url: url, method: method, headers: nil)
    }
    
    func photosResource(token: String) -> Resource<PhotosResponse> {
        guard let url = URL(string: "https://api.instagram.com/v1/users/self/media/recent?\(["access_token" : token])") else {
            fatalError("Can't create URL")
        }
        return Resource<PhotosResponse>(url: url, method: HttpMethod<Data>.get, headers: nil)
    }
}
