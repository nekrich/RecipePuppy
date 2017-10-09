//
//  RecipePuppyAPI.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

class RecipePuppyAPI: RecipesFetchAPIProtocol {
	
	enum Error: Swift.Error, LocalizedError {
		case noData
		case wrongSatusCode(Int)
	}
	
	@discardableResult
	func getRecipes(
		of dishName: String,
		locatedAt pageIndex: UInt,
		completionHandler: @escaping (Result<[RecipeProtocol]>) -> Void)
		-> URLSessionDataTask
	{
		
		let url: URL = buildURLToFetchRecipes(of: dishName, locatedAt: pageIndex)
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			
			guard error == nil
				else {
					completionHandler(.failure(error!))
					return
			}
			
			guard let data = data
				else {
					completionHandler(.failure(Error.noData))
					return
			}
			
			self.handleFetchRecipesResponseData(data,
			                                    handler: completionHandler)
			
		}
		
		task.resume()
		
		return task
		
	}
	
	private func buildURLToFetchRecipes(
		of dishName: String,
		locatedAt pageIndex: UInt)
		-> URL
	{
		
		let url: URL = URL(string: "http://www.recipepuppy.com/api/")!
		
		var urlComponents = URLComponents(url: url,
		                                  resolvingAgainstBaseURL: false)!
		
		urlComponents.queryItems = [
			URLQueryItem(name: "q", value: dishName),
			URLQueryItem(name: "p", value: "\(pageIndex)")
		]
		
		return urlComponents.url!
		
	}
	
	private func handleFetchRecipesResponseData(
		_ data: Data,
		handler: @escaping (Result<[RecipeProtocol]>) -> Void)
	{
		
		let recipesResult: RecipePuppyResult
		do {
			recipesResult = try JSONDecoder().decode(RecipePuppyResult.self, from: data)
		} catch {
			handler(.failure(error))
			return
		}
		
		handler(.success(recipesResult.recipes))
		
	}
	
	private struct RecipePuppyResult: Decodable {
		let recipes: [Recipe]
		private enum CodingKey: String, Swift.CodingKey {
			case recipes = "results"
		}
		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKey.self)
			recipes = try container.decode([Recipe].self, forKey: .recipes)
		}
	}
	
}
