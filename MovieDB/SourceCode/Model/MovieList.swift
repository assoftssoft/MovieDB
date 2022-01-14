//
//  MovieList.swift
//  MovieDB
//
//  Created by Waseem Ahmed on 14/01/2022.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct MovieList: Codable {
    var page: Int?
    var results: [Result]
    var totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        public var description: String  {
            return ""
        }
    }
    
    
    static func getServiceWithParam(param:[String:AnyObject] , urlValue: String) -> String {
          var urlComponents = URLComponents(string: urlValue)
          
          var queryItems = [URLQueryItem]()
          //                var url = "\(urlValue)?"
          for key in param.keys {
              queryItems.append(URLQueryItem(name: key, value: param[key] as? String ?? ""))
              //                        url += "\(key)=\(param[key]!)&"
          }
          urlComponents?.queryItems = queryItems
          
          return urlComponents?.string ?? ""
      }
  
    
    static func searchMovie(query : String , completion:@escaping ((MovieList)->()))  {
        
//        let url = WebServicesConstants.URL.kSearchMovie+"?api_key=\(apikey)"+"&query=\(query)"+"&language=\(language)"
        
       
        let url =  MovieList.getServiceWithParam(param: ["api_key":AppConstant.MovieMDKey,"query":query] as! [String:AnyObject], urlValue: WebServicesConstants.Server.BaseUrl)
        
        //"https://api.themoviedb.org/3/search/movie?api_key=e6b38212baf459bc1749d1e0fa386e4c&query=   a"
        
        WebServiceManager.sharedInstance.getRequest(urlString: url, paramDict : [:]) { (data, status, error) in
            
            if status! {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(MovieList.self, from: data!.toSwiftData())
                    print("response = ", data)
                    completion(response)
                    
                }catch {
                    print("Error = ", error)
                }
            }
            
        }
    }
    
    
  
}

// MARK: - Result
struct Result: Codable {
    var adult: Bool?
    var backdropPath: String?
    var genreIDS: [Int?]
    var id: Int?
    var originalLanguage, originalTitle, overview: String?
    var popularity: Double?
    var posterPath, releaseDate, title: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        public var description: String  {
            return ""
        }
    }
}

