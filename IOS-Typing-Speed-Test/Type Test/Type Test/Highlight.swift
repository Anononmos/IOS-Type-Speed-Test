//
//  Highlight.swift
//  Type Test
//
//  Created by Kashif Mushtaq on 2021-06-12.
//

import Foundation
import SwiftUI

public struct TextStyle {
    internal let key: NSAttributedString.Key
    internal let apply: (Text) -> Text
    
    private init(key: NSAttributedString.Key, apply: @escaping (Text) -> Text) {
        self.key = key
        self.apply = apply
    }
}

public extension TextStyle {
    static func foregroundColour(_ colour: Color) -> TextStyle {
        TextStyle(key: .init("TextStyleForegroundColor"), apply: { $0.foregroundColor(colour) })
    }
}

public struct StyledText {
    
    private var attributedString: NSAttributedString
    
    private init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
    }
    
    public func style<S>(_ style: TextStyle, ranges: (String) -> S) -> StyledText
        where S: Sequence, S.Element == Range<String.Index>?
    {
        let newAttributedString = NSMutableAttributedString(attributedString: attributedString)
        
        for range in ranges(attributedString.string).compactMap({ $0 }) {
            let nsRange = NSRange(range, in: attributedString.string)
            newAttributedString.addAttribute(style.key, value: style, range: nsRange)
        }
        
        return StyledText(attributedString: newAttributedString)
    }
}

extension StyledText {
    public init(verbatim content: String, styles: [TextStyle] = []) {
        let attributes = styles.reduce(into: [:]) { (result, style) in
            result[style.key] = style
        }
        attributedString = NSMutableAttributedString(string: content, attributes: attributes)
    }
}

extension StyledText: View {
    public var body: some View { text() }
    
    public func text() -> Text {
        var text: Text = Text(verbatim: "")
        attributedString
            .enumerateAttributes(in: NSRange(location: 0, length: attributedString.length), options: []) { (attributes, range, _) in
            
            let string = attributedString.attributedSubstring(from: range).string
            let modifiers = attributes.values.map { $0 as! TextStyle }
            text = text + modifiers.reduce(Text(verbatim: string)) { (segment, style) in
                style.apply(segment)
            }
        }
        return text
    }
}

public extension TextStyle {
    static func highlight(_ colour: Color = Color.clear) -> TextStyle { .foregroundColour(colour) }
}
