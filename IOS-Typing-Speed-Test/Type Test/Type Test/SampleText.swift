//
//  SampleText.swift
//  Type Test
//
//  Created by Kashif Mushtaq on 2021-06-04.
//

import Foundation
import UIKit

struct SampleText {
    
    private let count = [
        "Sample0" : 69,
        "Sample1" : 107,
        "Sample2" : 74
    ]
    private let id = Int.random(in: 0...2)
    
    private var fileName: String
    private var text: String?
    private var sentences: [String]?
    var wordCount: Int
    
    init() {
        fileName = "Sample" + String(id)
        wordCount = count[fileName]!
        
        if let asset = NSDataAsset(name: fileName) {
            let data = asset.data
            text = String(decoding: data, as: UTF8.self)
        }
        if let sentences = text?.components(separatedBy: "\n") {
            self.sentences = sentences
        }
    }
    
    func getSentence(line: Int) throws -> String? {
        
        guard sentences != nil else {
            throw AssetError.FailureParsingAsset
        }
        
        if line >= 0 && line < sentences!.count {
            return sentences![line]
        }
        return nil
    }
}

enum AssetError: Error {
    case FailureParsingAsset
}
