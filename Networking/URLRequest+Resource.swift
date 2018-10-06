// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: Расширение для URLRequest. Связь URLRequest c Resource.

import Foundation

extension URLRequest {
	init<A>(resource: Resource<A>){
		self.init(url: resource.url)
		httpMethod = resource.method.stringValue
		if case let .post(data) = resource.method {
			httpBody = data
		}
		allHTTPHeaderFields = resource.headers
	}
}
