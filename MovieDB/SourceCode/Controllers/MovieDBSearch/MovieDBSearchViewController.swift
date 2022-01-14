//
//  MovieDBSearchViewController.swift
//  MovieDB
//
//  Created by Ahmed on 14/01/2022.
//

import UIKit

class MovieDBSearchViewController: UIViewController, SelectSuggestionDelegate {
    
    
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var tableView: MovieDBTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        registerCell()
        tableView.selectSuggestionDelegate = self
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton")as? UIButton {
            
            clearButton.addTarget(self, action: #selector(self.cancelBtn), for: .touchUpInside)
        }
    }
    
    func registerCell() {
        
        for cell in [MovieDBSearchTableViewCell.nameOfClass()]{
            let cellNib = UINib(nibName: cell, bundle: nil)
            self.tableView.register(cellNib, forCellReuseIdentifier: cell)
        }
    }
    

    @objc func cancelBtn() {
        self.tableView.movieList.removeAll()
        self.tableView.reloadData()
        self.tableView.isSearchActive = true
        self.view.endEditing(true)
    }
    
    
}


