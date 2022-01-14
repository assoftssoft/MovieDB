//
//  MovieDBSearchTableViewCell.swift
//  MovieDB
//
//  Created by  Ahmed on 14/01/2022.
//

import UIKit
import SDWebImage
class MovieDBSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.movieImage.layer.cornerRadius = self.movieImage.layer.frame.height/2
        self.movieImage.clipsToBounds = true
    }
    
    func objInit(url : String?){
        
            if let imageURL = url, let url = URL.init(string: imageURL) {
                self.movieImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                print("url",url)
                self.movieImage.sd_setImage(with: url)
            }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
