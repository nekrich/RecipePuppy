//
//  Result.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

enum Result<Value> {
	
	case success(Value)
	case failure(Error)
	
	/// Returns `true` if the result is a success, `false` otherwise.
	public var isSuccess: Bool {
		switch self {
		case .success:
			return true
		case .failure:
			return false
		}
	}
	
	/// Returns `true` if the result is a failure, `false` otherwise.
	public var isFailure: Bool {
		return !isSuccess
	}
	
	/// Returns the associated value if the result is a success, `nil` otherwise.
	public var value: Value? {
		switch self {
		case .success(let value):
			return value
		case .failure:
			return nil
		}
	}
	
	/// Returns the associated error value if the result is a failure, `nil` otherwise.
	public var error: Error? {
		switch self {
		case .success:
			return nil
		case .failure(let error):
			return error
		}
	}
	
}
