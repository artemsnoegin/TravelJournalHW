//
//  ImageFileManager.swift
//  TravelJournalHW
//
//  Created by Артём Сноегин on 07.11.2025.
//

import UIKit

class ImageFileManager {
    
    static let shared = ImageFileManager()
    
    private let fileManager = FileManager.default
    
    private var documentsPath: URL { fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! }
    
    
    func createDirectory(_ directoryName: String) -> URL {
        
        var directoryNumber = 0
        
        var validDirectoryName = directoryName.replacing(" ", with: "_") + String(directoryNumber)
        
        var directoryPath = documentsPath.appendingPathComponent(validDirectoryName)
        
        while fileManager.fileExists(atPath: directoryPath.path()) {
            
            directoryNumber += 1
            validDirectoryName = directoryName.replacing(" ", with: "_") + String(directoryNumber)
            directoryPath = documentsPath.appendingPathComponent(validDirectoryName)
        }

        do {
            try fileManager.createDirectory(atPath: directoryPath.path(), withIntermediateDirectories: true)
        }
        catch {
            print(error.localizedDescription)
        }
        
        
        return directoryPath
    }
    
    func saveImage(_ image: UIImage, directoryPath: URL, fileName: String) -> URL {
        
        let data = image.pngData()
        
        let imagePath = directoryPath.appendingPathComponent(fileName + ".png")
        
        fileManager.createFile(atPath: imagePath.path(), contents: data)
        
        return imagePath
    }
    
    func loadImage(imagePath: String) -> UIImage? {
        
        if let url = URL(string: imagePath) {
            
            do {
                try print(url.deletingLastPathComponent().path())
            }
            catch {
            }
            
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
