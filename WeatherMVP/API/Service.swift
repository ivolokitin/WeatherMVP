//
//  Service.swift
//  WeatherMVP
//
//  Created by Ivan Volokitin on 21.08.2020.
//  Copyright © 2020 Ivan Volokitin. All rights reserved.
//

import Foundation

func decodeJSON<T: Decodable>(urlString: String, modelType: T.Type, completion: @escaping (T?) -> ()) {
    
    guard let url = URL(string: urlString) else {
        fatalError("URL is incorrect")
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        guard let data = data, error == nil else {
            print(error!.localizedDescription)
            completion(nil)
            return
        }
        
        let response = try? JSONDecoder().decode(modelType, from: data)
        if let response = response {
            completion(response)
        }
    }.resume()
}
