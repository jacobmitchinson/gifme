//
//  WebService.swift
//  GifMe
//
//  Created by Hussain, Shabeer (UK - London) on 21/06/2016.
//  Copyright © 2016 Deloitte Digital. All rights reserved.
//

import Foundation

enum Method:String {
    case Search = "search"
}

enum Parameter:String {
    case Query = "q"
}

enum GifResult {
    case Success([Gif])
    case Failure(ErrorProtocol)
}

enum GiphyError: ErrorProtocol {
    case InvalidJSONData
    case InvalidSearch
}

struct GiphyAPI {
    
    private static let baseURLString = "http://api.giphy.com/v1/gifs/"
    private static let APIKey = "dc6zaTOxFJmzC"
    
    static func createURL(method:Method, parameters:[Parameter: String]?) -> URL? {
        guard var components = URLComponents(string:baseURLString + method.rawValue) else {
            return nil
        }
        
        var queryItems = [URLQueryItem]()
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key.rawValue, value: value)
                queryItems.append(item)
            }
        }
        
        let apiItem = URLQueryItem(name:"api_key", value: APIKey)
        queryItems.append(apiItem)
        
        components.queryItems = queryItems
        
        if let url = components.url {
            return url
        } else {
            return nil
        }
    }
    
    static func searchURL(text:String) -> URL? {
        let formattedText = self.formatText(text: text)
        let url = self.createURL(method: .Search, parameters: [.Query:formattedText])
        return url
    }
    
    private static func formatText(text:String) -> String {
        let textComponents = text.components(separatedBy:" ")
        let joinedByPlusText = textComponents.joined(separator: "+")
        return joinedByPlusText
    }
    
    static func gifURLsFromJSONData(data:Data) -> GifResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            var finalGifURLS = [Gif]()
            
            guard let
                jsonDictionary = jsonObject["data"] as? [[String:AnyObject]] else
            {
                return .Failure(GiphyError.InvalidJSONData)
            }
            
            for jsonObjects in jsonDictionary {
                if let gif = gifsFromJSONObject(json: jsonObjects) {
                    finalGifURLS.append(gif)
                }
            }
            
            return .Success(finalGifURLS)
        } catch let error {
            return .Failure(error)
        }
    }
    
    private static func gifsFromJSONObject(json: [NSObject:AnyObject]) -> Gif? {
        guard let
            images = json["images"] as? [String:AnyObject],
            urlString = images["original"]?["url"] as? String,
            url = URL(string:urlString) else {
                return nil
        }
        
        return Gif(url: url)
    }
    
}
