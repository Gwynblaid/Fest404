// Copyright (C) ABBYY (BIT Software), 1993-2017 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: Протокол для работы с сервером на основе ресурсов.

import Foundation

protocol NetworkHelperProtocol {
	func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation?
	func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation?
}

extension NetworkHelperProtocol {
	func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
		let container = RequestCancelContainer()
		container.requestCancel = self.load(resource: resource) { (result) in
			switch result {
			case .failure(_):
				if repeatTime > 0 {
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: {
						self.load(resource: resource, repeatTime: repeatTime - 1, delayTime: delayTime, container: container, completion: completion)
					});
				}else{
					completion(result)
				}
			case .success(_):
				completion(result)
			}
		}
		return container
	}
	
	private func load<A>(resource: Resource<A>, repeatTime: Int, delayTime: TimeInterval, container: RequestCancelContainer, completion: @escaping (OperationCompletion<A>) -> ()) {
		container.requestCancel = self.load(resource: resource) { (result) in
			switch result {
			case .failure(_):
				if repeatTime > 0 {
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime, execute: {
						self.load(resource: resource, repeatTime: repeatTime - 1, delayTime: delayTime, container: container, completion: completion)
					});
				}else{
					completion(result)
				}
			case .success(_):
				completion(result)
			}
		}
	}
	
}


