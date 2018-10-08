// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

import Foundation

extension  InstagramApiClient {
    enum Errors: Error {
        case noToken
    }
    
    @objc func requestMyPhotos(success: @escaping ([InstagramPhotoData]) -> (), failure: @escaping (Error) -> ()) {
        let helper = NetworkHelper()
        guard let token = token else {
            failure(Errors.noToken)
            return
        }
        let resource = ModelResourceFactory().photosResource(token: token)
        _ = helper.load(resource: resource, completion: { res in
            switch res {
            case .success(let result):
                success(result.photos)
            case .failure(let error):
                failure(error)
            }
        })
    }
}
