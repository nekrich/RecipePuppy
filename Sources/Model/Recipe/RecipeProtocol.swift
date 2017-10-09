//
//  RecipeProtocol.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

protocol RecipeProtocol {
	
	var title: String { get }
	var link: URL { get }
	var ingredients: [String] { get }
	var thumbnailURL: URL? { get }
	
}
