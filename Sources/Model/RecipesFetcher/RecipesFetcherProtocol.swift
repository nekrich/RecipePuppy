//
//  RecipesFetcherProtocol.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

protocol RecipesFetcherDelegate: class {
	func recipesFetcher(_ recipesFetcher: RecipesFetcherProtocol, didFetch newRecipes: [RecipeProtocol])
}

protocol RecipesFetcherProtocol: class {
	
	func updateDishName(to newDishName: String?)
	
	var delegate: RecipesFetcherDelegate? { get set }
	
	var recipes: [RecipeProtocol] { get }
	
	var isThereMoreRecipes: Bool { get }
	
	func loadMoreRecipes()
	
}
