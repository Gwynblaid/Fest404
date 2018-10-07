// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: Ресурс содержащий все необходимые параметры для создания и обрабоки запроса

import Foundation

struct Resource<ResourceType> {
	let url: URL
	let method: HttpMethod<Data>
	let parse: (Data) throws -> ResourceType
	let headers: [String : String]?
	
	init(url: URL, method: HttpMethod<Data>, parse: @escaping (Data) throws -> ResourceType, headers: [String : String]?) {
		self.url = url
		self.method = method
		self.parse = parse
		self.headers = headers
	}
}
