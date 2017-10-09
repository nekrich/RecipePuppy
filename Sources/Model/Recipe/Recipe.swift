//
//  Recipe.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

struct Recipe: RecipeProtocol, Decodable {
	
	enum Error: Swift.Error, LocalizedError {
		case badRecipeURL
	}
	
	private enum CodingKey: String, Swift.CodingKey {
		
		case title
		case link = "href"
		case ingredients
		case thumbnailURLString = "thumbnail"
		
	}
	
	let title: String
	let link: URL
	let ingredients: [String]
	let thumbnailURL: URL?
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: CodingKey.self)

		guard let link: URL = URL(string: try container.decode(String.self, forKey: .link))
			else {
				throw Error.badRecipeURL
		}
		
		let title: String = try container.decode(String.self, forKey: .title)
		
		let ingredients: [String] = (try container.decode(String.self,
		                                        forKey: .ingredients))
			.components(separatedBy: ", ")
		
		let thumbnailURLString: String = try container.decode(String.self, forKey: .thumbnailURLString)
		let thumbnailURL: URL? = URL(string: thumbnailURLString)
		
		self.init(title: title,
		          link: link,
		          ingredients: ingredients,
		          thumbnailURL: thumbnailURL)
		
	}
	
	private init(
		title: String,
		link: URL,
		ingredients: [String],
		thumbnailURL: URL?)
	{
		
		self.title = title
		self.link = link
		self.ingredients = ingredients
		self.thumbnailURL = thumbnailURL
		
	}
	
}
