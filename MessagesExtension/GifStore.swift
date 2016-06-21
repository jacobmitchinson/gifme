//
//  GifStore.swift
//  GifMe
//
//  Created by DeepThought on 21/06/2016.
//  Copyright © 2016 Deloitte Digital. All rights reserved.
//

import UIKit

class GifStore {
    
    let session: URLSession = {
        let config  = URLSessionConfiguration.default()
        return URLSession(configuration: config)
    }()
    
    func fetchWithSearchText(text: String, completion: (GifResult) -> Void)
    {
        guard let url = GiphyAPI.searchURL(text: text) else {
            return completion(.Failure(GiphyError.InvalidSearch))
        }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let result = self.processGifRequest(data: data, error: error) {
                completion(result)
            }
        });
        task.resume()
    }
    
    func processGifRequest(data:Data?, error:ErrorProtocol?) -> GifResult? {
        guard let jsonData = data else {
            if let error = error {
                return GifResult.Failure(error)
            }
            return nil
        }
        
        return GiphyAPI.gifURLsFromJSONData(data: jsonData)
    }
    
}
