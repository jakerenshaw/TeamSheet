//
//    Copyright (c) 2016 Mikhail Motylev https://twitter.com/mikhail_motylev
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public extension SKStyle {
    
    // MARK: - Abstract properties
    var color: UIColor? {
        return colorValue(forKey: #function)
    }
    
    var size: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
   
    // MARK: - [View] Properties
    
    /// Background color, can be applied to any View
    var backgroundColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    /// Cackground radius, can be applied to any View
    var cornerRadius: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Border width, can be applied to any View
    var borderWidth: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Border color, can be applied to any View
    var borderColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    /// Alpha, can be applied to any View
    var alpha: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Shadow radius, can be applied to any View
    var shadowRadius: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Shadow offset, can be applied to any View
    var shadowOffset: CGSize? {
        
        if let str = stringValue(forKey: #function) {
            return NSCoder.cgSize(for: str)
        }
        
        return nil
    }
    
    /// Tint color, can be applied to any View
    var tintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    /// Shadow color, can be applied to any View
    var shadowColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    /// Shadow opacity, can be applied to any View
    var shadowOpacity: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    // MARK: - [Control] Properties
    
    var contentVerticalAlignment: UIControl.ContentVerticalAlignment? {
        return SKControlContentVerticalAlignment.from(rawValue: stringValue(forKey: #function))?.alignment
    }
    
    var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment? {
        return SKControlContentHorizontalAlignment.from(rawValue: stringValue(forKey: #function))?.alignment
    }
    
    // MARK: - [Slider] Properties
    
    var minimumTrackTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    var maximumTrackTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    // MARK: - [Switch] Properties
    
    /// On tint color, can be applied to Switch
    var onTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    /// Thumb tint color, can be applied to Switch
    var thumbTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    // MARK: - [Progress View] Properties
    
    var progressTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    var trackTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    // MARK: - [Activity Indicator] Properties
    var activityIndicatorColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    // MARK: - [Tab Bar] Properties
    
    /// Bar tint color
    var barTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    /// Unselected items in this tab bar will be tinted with this color iOS 10+
    var unselectedItemTintColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    // MARK: - [Navigation Bar] Properties 
    var isTranslucent: Bool? {
        return boolValue(forKey: #function)
    }
    
    // MARK: - [Font] Properties
    
    /// Font name, can be applied to text containers (Label, TextField, TextView)
    var fontName: String? {
        return stringValue(forKey: #function)
    }
    
    /// Font style, can be applied to text containers (Label, TextField, TextView)
    var fontStyle: String? {
        return stringValue(forKey: #function)
    }
    
    /// Font size, can be applied to text containers (Label, TextField, TextView)
    var fontSize: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Font color, can be applied to text containers (Label, TextField, TextView)
    var fontColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    /// Font kern, can be applied to text containers (Label, TextField, TextView)
    var fontKern: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Font line spacing, can be applied to text containers (Label, TextField, TextView)
    var fontLineSpacing: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Font line height multiplier, can be applied to text containers (Label, TextField, TextView)
    var fontLineHeightMultiple: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Font minimum line height, can be applied to text containers (Label, TextField, TextView)
    var fontMinimumLineHeight: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Font maximum line height, can be applied to text containers (Label, TextField, TextView)
    var fontMaximumLineHeight: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    // MARK: - [Text] Properties
    
    /// Text aligment, can be applied to text containers (Label, TextField, TextView)
    var textAlignment: NSTextAlignment? {
        return SKTextAlignment.from(rawValue: stringValue(forKey: #function))?.alignment
    }
    
    /// Text paragraph spacing, can be applied to text containers (Label, TextField, TextView)
    var textParagraphSpacing: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Text paragraph first line head indent, can be applied to text containers (Label, TextField, TextView)
    var textParagraphFirstLineHeadIndent: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Text paragraph head indent, can be applied to text containers (Label, TextField, TextView)
    var textParagraphHeadIndent: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Text paragraph tail indent, can be applied to text containers (Label, TextField, TextView)
    var textParagraphTailIndent: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Text paragraph spacing before, can be applied to text containers (Label, TextField, TextView)
    var textParagraphSpacingBefore: CGFloat? {
        return cgFloatValue(forKey: #function)
    }
    
    /// Text hypernation factor, can be applied to text containers (Label, TextField, TextView)
    var textHyphenationFactor: Float? {
        return cgFloatValue(forKey: #function).map({ Float($0) })
    }
    
    /// Text underline style, can be applied to text containers (Label, TextField, TextView)
    var textUnderline: NSUnderlineStyle? {
        return SKUnderlineStyle.from(rawValue: stringValue(forKey: #function))?.style
    }
    
    /// Text underline pattern, can be applied to text containers (Label, TextField, TextView)
    var textUnderlinePattern: NSUnderlineStyle? {
        return SKUnderlinePatternStyle.from(rawValue: stringValue(forKey: #function))?.style
    }
    
    /// Text underline color
    var textUnderlineColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    // Text strikethrough style, can be applied to text containers (Label, TextField, TextView)
    var textStrikethrough: NSUnderlineStyle? {
        return SKUnderlineStyle.from(rawValue: stringValue(forKey: #function))?.style
    }
    
    /// Text strikethrough pattern, can be applied to text containers (Label, TextField, TextView)
    var textStrikethroughPattern: NSUnderlineStyle? {
        return SKUnderlinePatternStyle.from(rawValue: stringValue(forKey: #function))?.style
    }
    
    /// Text strikethrough color
    var textStrikethroughColor: UIColor? {
        return colorValue(forKey: #function)
    }
    
    // MARK: - Calculated text attributes
    /**
        This method can be used to get UIFont from style (if you need to pass it somewhere)

        - returns: UIFont object or nil if no fontName or fontSize or fontStyle specified
    */
    func font() -> UIFont? {
        
        guard fontName != nil || self.fontSize != nil || fontStyle != nil else {
            return nil
        }
        
        let fontSize = self.fontSize ?? UIFont.systemFontSize
        
        if let fontName = fontName {
            
            let fullFontName = (fontStyle == nil) ? fontName : "\(fontName)-\(fontStyle!)"
            let result: UIFont? = UIFont(name: fullFontName, size: fontSize)
            
            if result == nil {
                StyleKit.log("Style kit: No font with name \(fullFontName)", onlyOnce: true)
            }
            
            return result
        }
        else {
            
            if let fontStyle = self.fontStyle {
            
                if let style = SKFontStyle.from(rawValue: fontStyle) {
                    return style.systemFont(ofSize: fontSize)
                } else {
                    StyleKit.log("Style kit: No system font with style \"\(fontStyle)\", using default style", onlyOnce: true)
                }
            }

            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    func paragraphStyle(defaultParagraphStyle: NSParagraphStyle? = nil) -> NSParagraphStyle? {
        
        var resultIsEmpty = true
        let result = (defaultParagraphStyle?.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        
        if let fontLineSpacing = fontLineSpacing {
            
            result.lineSpacing = fontLineSpacing
            resultIsEmpty = false
        }
        
        if let fontLineHeightMultiple = fontLineHeightMultiple {
            
            result.lineHeightMultiple = fontLineHeightMultiple
            resultIsEmpty = false
        }
        
        if let fontMinimumLineHeight = fontMinimumLineHeight {
            
            result.minimumLineHeight = fontMinimumLineHeight
            resultIsEmpty = false
        }
        
        if let fontMaximumLineHeight = fontMaximumLineHeight {
            
            result.maximumLineHeight = fontMaximumLineHeight
            resultIsEmpty = false
        }
        
        if let textParagraphSpacing = textParagraphSpacing {
            
            result.paragraphSpacing = textParagraphSpacing
            resultIsEmpty = false
        }
        
        if let textParagraphFirstLineHeadIndent = textParagraphFirstLineHeadIndent {
            
            result.firstLineHeadIndent = textParagraphFirstLineHeadIndent
            resultIsEmpty = false
        }
        
        if let textParagraphHeadIndent = textParagraphHeadIndent {
            
            result.headIndent = textParagraphHeadIndent
            resultIsEmpty = false
        }
        
        if let textParagraphTailIndent = textParagraphTailIndent {
            
            result.tailIndent = textParagraphTailIndent
            resultIsEmpty = false
        }
        
        if let textParagraphSpacingBefore = textParagraphSpacingBefore {
            
            result.paragraphSpacingBefore = textParagraphSpacingBefore
            resultIsEmpty = false
        }
        
        if let textHyphenationFactor = textHyphenationFactor {
            
            result.hyphenationFactor = textHyphenationFactor
            resultIsEmpty = false
        }
        
        return resultIsEmpty ? nil : result
    }
    
    /**
         This method can be used to get text attributes from style (if you need to pass them somewhere)
     
         - parameter defaultParagraphStyle: Paragraph style to apply before applying text attributes from style (mainly for internal purposes) (default nil)
     
         - returns: Text attributes dictionary
    */
    func textAttributes(defaultParagraphStyle: NSParagraphStyle? = nil) -> [NSAttributedString.Key: Any]? {
        
        var result = [NSAttributedString.Key: Any]()
        
        if let font = font() {
            result.updateValue(font, forKey: NSAttributedString.Key.font)
        }
        
        if let fontColor = fontColor {
            result.updateValue(fontColor, forKey: NSAttributedString.Key.foregroundColor)
        }
        
        if let kern = fontKern {
            result.updateValue(kern, forKey: NSAttributedString.Key.kern)
        }
        
        if let paragraphStyle = paragraphStyle(defaultParagraphStyle: defaultParagraphStyle) {
            result.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
        }
        
        if let strikethroughStyle = textStrikethrough {
            
            var value: [NSUnderlineStyle] = [strikethroughStyle]
            
            if let strikethroughPatternStyle = textStrikethroughPattern {
                value.append(strikethroughPatternStyle)
            }
            
            result.updateValue(value.reduce(0, { $0 | $1.rawValue }), forKey: NSAttributedString.Key.strikethroughStyle)
            
            if let textStrikethroughColor = textStrikethroughColor {
                result.updateValue(textStrikethroughColor, forKey: NSAttributedString.Key.strikethroughColor)
            }
        }
        
        if let underlineStyle = textUnderline {
            
            var value: [NSUnderlineStyle] = [underlineStyle]
            
            if let underlinePatternStyle = textUnderlinePattern {
                value.append(underlinePatternStyle)
            }
            
            result.updateValue(value.reduce(0, { $0 | $1.rawValue }), forKey: NSAttributedString.Key.underlineStyle)
            
            if let textUnderlineColor = textUnderlineColor {
                result.updateValue(textUnderlineColor, forKey: NSAttributedString.Key.underlineColor)
            }
        }
        
        return result.isEmpty ? nil : result
    }
}
