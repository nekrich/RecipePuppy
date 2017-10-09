//
//  RecipePuppyRecipesFetcher.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import Foundation

class RecipePuppyRecipesFetcher: RecipesFetcherProtocol {
	
	weak var delegate: RecipesFetcherDelegate?
	
	private let api: RecipesFetchAPIProtocol = RecipePuppyAPI()
	
	private var queue: OperationQueue!
	
	private var atomicRecipes: Atomic<[RecipeProtocol]> = Atomic(value: [])
	
	var recipes: [RecipeProtocol] {
		return atomicRecipes.value
	}
	
	private var atomicIsThereMoreRecipes: Atomic<Bool> = Atomic(value: true)
	
	var isThereMoreRecipes: Bool {
		return atomicIsThereMoreRecipes.value
	}
	
	private(set) var nextPageToFetch: UInt = 1

	
	private var dishName: String? {
		didSet {
			guard
				dishName != .none
					&& dishName != oldValue
				else {
					return
			}
			cancelAllTasks()
			fetchData()
		}
	}
	
	private func cancelAllTasks() {
		queue?.cancelAllOperations()
		URLSession.shared.getTasksWithCompletionHandler { (tasks, _, _) in
			tasks.forEach { $0.cancel() }
		}
		queue = {
			let queue = OperationQueue()
			queue.name = "RecipePuppyRecipesFetcher"
			queue.maxConcurrentOperationCount = 1
			return queue
		}()
		queue.addOperation {
			self.nextPageToFetch = 1
		}
	}
	
	func updateDishName(to newDishName: String?) {
		dishName = newDishName
		if newDishName == .none {
			self.atomicIsThereMoreRecipes.value = false
			self.atomicRecipes.value = []
			DispatchQueue.main.async {
				self.delegate?.recipesFetcher(self, didFetch: [])
			}
		}
	}
	
	func loadMoreRecipes() {
		guard atomicIsThereMoreRecipes.value
			else {
				return
		}
		fetchData()
	}
	
	private func fetchData() {
		
		guard let dishName = dishName
			else {
				return
		}
		
		let queue: OperationQueue = self.queue
		queue.addOperation {
			self.self.api.getRecipes(of: dishName, locatedAt: self.nextPageToFetch) { [queue] (result) in
				guard
					self.queue == queue,
					let newRecipes = result.value
					else {
						return
				}
				queue.addOperation {
					if self.nextPageToFetch == 1 {
						self.atomicRecipes.value = newRecipes
					} else {
						self.atomicRecipes.value.append(contentsOf: newRecipes)
					}
					self.atomicIsThereMoreRecipes.value = !newRecipes.isEmpty
					self.nextPageToFetch += 1
					DispatchQueue.main.async {
						self.delegate?.recipesFetcher(self, didFetch: newRecipes)
					}
				}
			}
		}
		
	}
	
}
