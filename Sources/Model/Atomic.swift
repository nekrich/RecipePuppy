//
//  Atomic.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

struct Atomic<Value> {
	
	private var lock: NSLock = NSLock()
	
	private var _value: Value
	var value: Value {
		get {
			lock.lock(); defer { lock.unlock() }
			let value = _value
			return value
		}
		set {
			lock.lock(); defer { lock.unlock() }
			_value = newValue
		}
	}
	
	init(value: Value) {
		self._value = value
	}
	
}
