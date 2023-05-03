//
//  TypeManager.swift
//  Type Test
//
//  Created by Kashif Mushtaq on 2021-06-07.
//

import Foundation

class TypeManager: ObservableObject {
    
    @Published var typed = "" {
        didSet {
            if typed.count > text.count && oldValue.count <= text.count {
                line += 1
            }
            else {
                if typed.count < oldValue.count && (index - 1) >= 0 {
                    index -= 1
                    
                }
                else if (index + 1) < text.count {
                    index += 1
                }
            }
        }
    }
    var line = 0 {
        didSet {
            reset()
        }
    }
    
    func resetIndex() {
        typed = ""
        index = -1
        errorCount = 0
    }
    
    private func reset() {
        typed = ""
        index = -1
        errorCount = 0
        corrections = [Bool?] (repeating: nil, count: text.count)
    }
    
    var index: Int
    var text: String {
        didSet {
            corrections = [Bool?] (repeating: nil, count: text.count)
        }
    }
    var errorCount: Int
    var corrections: [Bool?]
    
    init(index: Int = -1, text: String = "") {
        self.index = index
        self.text = text
        errorCount = 0
        corrections = [Bool?] ()
    }
}
