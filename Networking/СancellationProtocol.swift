// Copyright (C) ABBYY (BIT Software), 1993-2017 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: Протокол для объектов которые отменяют операции или какиее-то действия.

import Foundation

protocol Cancellation {
	func cancel()
}

enum OperationCompletion<A>{
	case success(A?)
	case failure(Error)
}

extension URLSessionTask : Cancellation {
	
}

class RequestCancelContainer : Cancellation {
	var requestCancel: Cancellation?
	
	func cancel() {
		requestCancel?.cancel()
	}
}
