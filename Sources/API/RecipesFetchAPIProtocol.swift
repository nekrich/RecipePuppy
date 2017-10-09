//
//  RecipesFetchAPIProtocol.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

protocol RecipesFetchAPIProtocol {
	
	@discardableResult
	func getRecipes(
		of dishName: String,
		locatedAt pageIndex: UInt,
		completionHandler: @escaping (Result<[RecipeProtocol]>) -> Void)
		-> URLSessionDataTask
	
}
