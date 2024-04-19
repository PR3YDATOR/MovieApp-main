//
//  NetworkingManager.swift
//  MovieApp
//
//  Created by user238852 on 09/04/24.
//

import Foundation



class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    private let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    func searchForDrink(category: String, completion: @escaping ([DrinkModel]?, Error?) -> Void) {
        let endpoint = "filter.php?a=\(category)"
        guard let url = URL(string: baseURL + endpoint) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 1, userInfo: nil))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(DrinkListResponse.self, from: data)
                completion(result.drinks, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}

