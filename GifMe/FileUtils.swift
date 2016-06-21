//
//  FileUtils.swift
//  GifMe
//
//  Created by Hussain, Shabeer (UK - London) on 21/06/2016.
//  Copyright © 2016 Deloitte Digital. All rights reserved.
//

import Foundation

struct FileUtils {
    
    static func saveGif(url: URL?) -> String?
    {
        guard let url = url else
        {
            return nil
        }
        
        guard let gifData = NSData(contentsOf: url) else
        {
            return nil
        }
        
        let filePath = NSHomeDirectory().appending("/giphy.gif")
        gifData.write(to: URL(fileURLWithPath: filePath), atomically: true)
        
        return filePath
    }
    
    static func deleteGif(filePath:String?)
    {
        guard let filePath = filePath else
        {
            return
        }
        
        let fileManager = FileManager()
        do{
            let filePathURL = URL(string: filePath)
           try fileManager.removeItem(at: filePathURL!)
            print("Successfully deleted file at path :\n \(filePath)")
        }
        catch
        {
            print("Could not delete file at path :\n \(filePath)")
        }
    }
}
