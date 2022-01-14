//
//  SearchAndFindPicker.swift
//  WorldLocationPicker
//
//  Created by Malik Wahaj Ahmed on 21/03/2017.
//  Copyright © 2017 Malik Wahaj Ahmed. All rights reserved.
//

import Foundation
import UIKit


class SearchAndFindPicker : UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var previousSelectedRow: IndexPath!

    var contentKey :String! = "name"
    var dataTypeStr = ""
  
    var selectedData:[String:AnyObject]!
    var doneButtonTapped: (([String:AnyObject])->())?
    var cancelButtonTapped: (()->())?
    
    var filteredArray:[[String:AnyObject]] = []
    var dataArray = [[String:AnyObject]]()

    static func createPicker(dataArray: [[String:AnyObject]], typeStr : String) -> SearchAndFindPicker {
        let newViewController = UIStoryboard(name: "SearchAndFindPicker", bundle: nil).instantiateViewController(withIdentifier: "SearchAndFindPicker") as! SearchAndFindPicker
        newViewController.dataArray = dataArray
        newViewController.dataTypeStr = typeStr
        return newViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.placeholder = "Search \(dataTypeStr)"
        
        self.searchBar.setTextColor(color: .black)
        self.searchBar.setPlaceholderTextColor(color: .black)
        self.searchBar.setTextFieldColor(color: .clear)
        self.searchBar.setSearchImageColor(color: .black)
        self.searchBar.setTextFieldClearButtonColor(color: .black)
        
        backgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(tapGestureRecognizer:)))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)

        clearSelection()
        self.filteredArray = self.dataArray
    }
    
    @objc func backgroundTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        guard (selectedData) != nil else {
            print("Select \(dataTypeStr)")
            return
        }
        doneButtonTapped?(selectedData)
        self.close()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.close()
        cancelButtonTapped?()
    }
    
    func show(vc:UIViewController) {
        vc.addChild(self)
        vc.view.addSubview(self.view)
    }
    
    func close() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    func clearSelection() {
    
        var tempDataArray = [[String:AnyObject]]()
        for i in 0..<dataArray.count {
            var data = dataArray[i]
            data.updateValue(0 as AnyObject, forKey: "unselected")
            tempDataArray.append(data)
        }
        dataArray = tempDataArray
        //tableView.reloadData()
    }
    
}

extension SearchAndFindPicker : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.filteredArray = self.dataArray
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("here is text : ", searchText)
        
        filteredArray = dataArray.filter ({ (data) -> Bool in
            if let tmp = data[contentKey] as? NSString {
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            }
            return false
        })
        
        if searchText.count == 0 {
            self.filteredArray = self.dataArray
        }
        self.tableView.reloadData()
    }
    
}

extension SearchAndFindPicker : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAndFindCell", for: indexPath) as? SearchAndFindCell {
            cell.labelName.text = filteredArray[indexPath.row][contentKey] as? String
            cell.selectionStyle = .none
            cell.actionButton.isHidden = true
            

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if (previousSelectedRow != nil) {
            
            let previousRowCell = tableView.cellForRow(at: previousSelectedRow!) as? SearchAndFindCell
            previousRowCell?.actionButton.isHidden = true
        }
        previousSelectedRow = indexPath

        let indexPathSelectedRow = tableView.indexPathForSelectedRow
        
        let currentCell = tableView.cellForRow(at: indexPathSelectedRow!) as? SearchAndFindCell
            
        if let cell = currentCell {
            cell.actionButton.isHidden = false
            selectedData = filteredArray[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SearchAndFindPicker {
    
    @objc func keyBoardWillShow() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(movedUp: true)
        }
        else if self.view.frame.origin.y < 0 {
            setViewMovedUp(movedUp: false)
        }
    }
    
    @objc func keyBoardWillHide() {
        if self.view.frame.origin.y >= 0 {
            setViewMovedUp(movedUp: true)
        }
        else if self.view.frame.origin.y < 0 {
            setViewMovedUp(movedUp: false)
        }
    }
    
    func setViewMovedUp(movedUp: Bool){
        
        let kOffset:CGFloat = 0.0
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        
        var rect = self.view.frame
        
        if movedUp {
            rect.origin.y -= kOffset;
            rect.size.height += kOffset;
        }
        else
        {
            rect.origin.y += kOffset;
            rect.size.height -= kOffset;
        }
        self.view.frame = rect;
        UIView.commitAnimations()
    }
    
}
