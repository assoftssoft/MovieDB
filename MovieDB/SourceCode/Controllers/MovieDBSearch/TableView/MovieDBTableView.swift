//
//  MovieDBTableView.swift
//  MovieDB
//
//  Created by  Ahmed on 14/01/2022.
//

import UIKit
import SDWebImage

protocol SelectSuggestionDelegate {
    func didSelectSelection(text : String)
}
class MovieDBTableView: UITableView , UITableViewDelegate , UITableViewDataSource {
    
    var suggestions = [String]()
    var movieList = [Result]()
    var isSearchActive = Bool()
    var selectSuggestionDelegate : SelectSuggestionDelegate?
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchActive {
            return suggestions.count
        }else {
            return movieList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearchActive {
            let cell = UITableViewCell.init(frame: .zero)
            cell.textLabel?.text = suggestions[indexPath.row]
            return cell
            
        }else {
            let cell = self.dequeueReusableCell(withIdentifier: MovieDBSearchTableViewCell.nameOfClass(), for: indexPath) as! MovieDBSearchTableViewCell
            
            cell.movieName.text = movieList[indexPath.row].title
            let imageurl : String? = "http://image.tmdb.org/t/p/w185"+"\(movieList[indexPath.row].posterPath ?? "")"
        
            cell.objInit(url: imageurl)
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchActive {
            self.selectSuggestionDelegate?.didSelectSelection(text: suggestions[indexPath.row])
        }
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
