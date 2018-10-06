// Copyright (C) ABBYY (BIT Software), 1993-2017 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: Расширение для словаря для удобной работы с запросами.

import Foundation

extension String {
    var encodedParamForURL: String {
        var charset = CharacterSet.urlQueryAllowed
        charset.remove(charactersIn: "&")
        return self.addingPercentEncoding(withAllowedCharacters: charset) ?? ""
    }
}

extension Dictionary {
	var getString: String {
		return self.compactMap({ key, value in
			let stringValue = "\(value)"
			if stringValue.count > 0 {
				return "\(key)".encodedParamForURL + "=" + stringValue.encodedParamForURL
			}
			return nil
		}).joined(separator: "&")
	}
}
