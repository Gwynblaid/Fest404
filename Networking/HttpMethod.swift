// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: enum Описывающий тип запроса

import Foundation

enum HttpMethod<Body> {
	case get
	case post(Body)
}

extension HttpMethod {
	var stringValue: String{
		switch self {
		case .get:
			return "GET"
		case .post:
			return "POST"
		}
	}
	
	func map<B>(f: (Body) -> B) -> HttpMethod<B> {
		switch self {
		case .get:
			return .get
		case .post(let body):
			return .post(f(body))
		}
	}
}
