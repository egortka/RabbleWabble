//
//  DiskCaretaker.swift
//  RabbleWabble
//
//  Created by Egor Tkachenko on 20/11/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Foundation

public final class DiskCaretacker {
    
    public static let decoder = JSONDecoder()
    public static let encoder = JSONEncoder()
    
    public static func save<T: Codable>(
        _ object: T, to fileName: String) throws {
        
        do {
            
            let url = createDocumentURL(withFileName: fileName)
            let date = try encoder.encode(object)
            
            try date.write(to: url, options: .atomic)
            
        } catch {
            
            print("Failed to save object: '\(object)'. Error: \(error)")
            throw error
        }
    }
    
    public static func retrieve<T: Codable>(
        _ type: T.Type, from fileName: String) throws -> T {
    
        let url = createDocumentURL(withFileName: fileName)
        
        return try retrieve(type, from: url)
    }
    
    public static func retrieve<T: Codable>(
        _ type: T.Type, from url: URL) throws -> T {
    
        do {
            
            let data = try Data(contentsOf: url)
            
            return try decoder.decode(type, from: data)
            
        } catch  {
            
            print("Failed to read from URL: '\(url)'. Error: \(error)")
            throw error
        }
        
    }
    
    public static func createDocumentURL(
        withFileName fileName: String ) -> URL {
        
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory,
                                   in: .userDomainMask).first!
        return url.appendingPathComponent(fileName)
                  .appendingPathExtension(".json")
        
    }
    
}
