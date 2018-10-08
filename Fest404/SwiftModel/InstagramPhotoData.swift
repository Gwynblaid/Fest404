// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

import Foundation
import ObjectMapper

@objc class InstagramPhotoData: NSObject, ImmutableMappable {
    @objc var imageURLString: String
    
    required init(map: Map) throws {
        imageURLString = try map.value("images.standard_resolution.url")
    }
}
