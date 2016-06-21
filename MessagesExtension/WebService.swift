//
//  WebService.swift
//  GifMe
//
//  Created by Hussain, Shabeer (UK - London) on 21/06/2016.
//  Copyright © 2016 Deloitte Digital. All rights reserved.
//

import Foundation


struct WebService {
    
    func giphy(searchText: String)
    {
        guard let url = URL(string: "http://api.giphy.com/v1/gifs/search?q=funny+cat&api_key=dc6zaTOxFJmzC") else
        {
            return
        }
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default()
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            guard let data = data else
            {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("JSON : \(json)")
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
}
