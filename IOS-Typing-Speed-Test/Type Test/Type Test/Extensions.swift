//
//  Extensions.swift
//  Type Test
//
//  Created by Kashif Mushtaq on 2021-06-12.
//

import Foundation
import SwiftUI
import UIKit

#if canImport(UIKit)
extension View {
    public func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension String {
    
    public func asLetterArray() -> [String] {
        var array = [String] ()
        
        self.forEach {
            array.append(String($0))
        }
        return array
    }
    
    public func replaceChar(index: Int, with: String) -> String {
        let str1 = self[0..<index]
        let str2 = self[(index + 1)..<self.count]
        
        return str1 + with + str2
    }
    
    public func range(index: Int) -> Range<String.Index>? {
        
        guard index >= 0, index < count else {
            return nil
        }
        
        let start = self.index(startIndex, offsetBy: index)
        let end = self.index(after: start)
        
        return start..<end
    }
    
    public func ranges(_ f: @escaping (Bool) -> Bool = { $0 }, corrections: [Bool?] ) -> [Range<String.Index>?] {
        var array = [Range<String.Index>?] ()
        
        corrections.enumerated().forEach { (i, v) in
            if let value = v {
                if f(value) {
                    array.append(range(index: i))
                }
            }
        }
        return array
    }
}

extension StringProtocol {
    
    public subscript(offset: Int) -> String {
        return String(self[index(startIndex, offsetBy: offset)])
    }
    
    public subscript(bounds: Range<Int>) -> String {
        let start = bounds.lowerBound
        let end = bounds.upperBound
        
        return String(self[index(startIndex, offsetBy: start)..<index(startIndex, offsetBy: end)])
    }
}
