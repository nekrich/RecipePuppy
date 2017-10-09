//
//  RecipesListViewController.swift
//  RecipePuppy
//
//  Created by Vitalii Budnik on 10/9/17.
//  Copyright © 2017 Vitalii Budnik. All rights reserved.
//

import UIKit
import SafariServices

class RecipesListViewController: UIViewController {

	
	private let searchContoller = UISearchController(searchResultsController: .none)
	
	private lazy var fetcher: RecipesFetcherProtocol = {
		let recipesFetcher = RecipePuppyRecipesFetcher()
		recipesFetcher.delegate = self
		return recipesFetcher
	}()
	@IBOutlet private weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureSeachController()
		
	}
	
	private func configureSeachController() {
		
		self.definesPresentationContext = true
		
		searchContoller.dimsBackgroundDuringPresentation = false
		
		searchContoller.searchBar.sizeToFit()
		searchContoller.searchBar.delegate = self
		if #available(iOS 11.0, *) {
			navigationItem.searchController = searchContoller
			navigationItem.hidesSearchBarWhenScrolling = false
		} else {
			tableView.tableHeaderView = searchContoller.searchBar
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: selectedIndexPath, animated: animated)
		}
	}
	
}

extension RecipesListViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		fetcher.updateDishName(to: searchBar.text)
	}
	
	func searchBar(
		_ searchBar: UISearchBar,
		textDidChange searchText: String)
	{
		fetcher.updateDishName(to: searchText)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		fetcher.updateDishName(to: .none)
	}
	
}

extension RecipesListViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if fetcher.isThereMoreRecipes && !fetcher.recipes.isEmpty {
			return fetcher.recipes.count + 1
		} else {
			return fetcher.recipes.count
		}
		
	}
	
	func tableView(
		_ tableView: UITableView,
		cellForRowAt indexPath: IndexPath)
		-> UITableViewCell
	{
		
		if indexPath.row < fetcher.recipes.count {
		
			let cell: RecipeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell") as! RecipeTableViewCell
			
			cell.textLabel?.text = fetcher.recipes[indexPath.row].title
			
			return cell
			
		} else {
			
			let cell: SpinnerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SpinnerTableViewCell") as! SpinnerTableViewCell
			
			return cell
			
		}
		
	}
	
}

extension RecipesListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		guard cell is SpinnerTableViewCell
			else {
				return
		}
		fetcher.loadMoreRecipes()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let safariController = SFSafariViewController(url: fetcher.recipes[indexPath.row].link)
		self.present(safariController, animated: true, completion: .none)
	}

}

extension RecipesListViewController: RecipesFetcherDelegate {
	
	func recipesFetcher(
		_ recipesFetcher: RecipesFetcherProtocol,
		didFetch newRecipes: [RecipeProtocol])
	{
		tableView.reloadData()
	}
}
