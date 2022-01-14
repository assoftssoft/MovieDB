//
//  MovieDBSearchExtension.swift
//  MovieDB
//
//  Created by Waseem Ahmed on 14/01/2022.
//

import Foundation
import UIKit

extension MovieDBSearchViewController : UISearchBarDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("searchText",searchText)
        
        if searchText.isEmpty {
            self.tableView.movieList.removeAll()
            self.tableView.reloadData()
            self.tableView.isSearchActive = true
            self.view.endEditing(true)
            
        }
        if searchText.count > 0
        {
            self.tableView.isSearchActive = false
            MovieList.searchMovie(query: searchText) { responseObject in
                print(responseObject)
                self.tableView.movieList = responseObject.results
                self.tableView.reloadData()
            }
        }else {
            self.view.endEditing(true)
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            self.tableView.isSearchActive = true
            tableView.reloadData()
        }
        
        print("searchBarTextDidEndEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.isSearchActive = true
        tableView.reloadData()
        print("searchBarCancelButtonClicked")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tableView.isSearchActive = false
        self.tableView.suggestions.append(searchBar.text ?? "")
        self.tableView.reloadData()
        print("searchBarSearchButtonClicked")
        self.view.endEditing(true)
        
    }
    
    func didSelectSelection(text: String) {
        self.tableView.isSearchActive = false
        MovieList.searchMovie(query: text) { responseObject in
            print(responseObject)
            self.tableView.movieList = responseObject.results
            self.tableView.reloadData()
        }
    }
    
    
    
}
