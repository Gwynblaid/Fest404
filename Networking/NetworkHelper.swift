// Copyright (C) ABBYY (BIT Software), 1993-2017 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: Класс отправки запросов в сеть.

import Foundation
import Reachability


final class NetworkHelper : NetworkHelperProtocol {
    
    enum NetworkErrors: Error {
        case noConnection
    }
	
	func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
		if Reachability()?.connection == Reachability.Connection.none {
			completion(.failure(NetworkErrors.noConnection))
			return nil
		}
		let request = URLRequest(resource: resource)
		let task =  URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
			} else {
				do {
					let data = data ?? Data()
					try completion(.success(resource.parse(data)))
				} catch let error {
					completion(.failure(error))
				}
			}
		}
		task.resume()
		return task
	}
}
