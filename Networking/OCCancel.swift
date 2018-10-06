// Copyright (C) ABBYY (BIT Software), 1993-2018 . All rights reserved.
// Автор: Sergey Kharchenko
// Описание: Обертка над протоколом Cancellation для ObjC.
//TODO: Удалить как только избавимся от его исопльзования в ObjC-коде

import Foundation

class OCCancel: NSObject {

	var cancel: Cancellation
	
	init?(cancel: Cancellation?) {
        guard let sCancel = cancel else {return nil}
		self.cancel = sCancel
		super.init()
	}
	
	@objc func abort() -> () {
		self.cancel.cancel()
	}
}
