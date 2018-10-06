// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko

import Foundation
import ObjectMapper

struct TokenData: ImmutableMappable {
    var token: String
    
    init(map: Map) throws {
        token = try map.value("access_token")
    }
}
