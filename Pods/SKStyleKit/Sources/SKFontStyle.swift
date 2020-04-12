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

enum SKFontStyle: String {
    
    case ultraLight = "ultralight"
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
    case italic
    
    @available(iOS 8.2, *)
    var weight: UIFont.Weight? {
        
        switch self {
            
            case .ultraLight: return UIFont.Weight.ultraLight
            case .thin: return UIFont.Weight.thin
            case .light: return UIFont.Weight.light
            case .regular: return UIFont.Weight.regular
            case .medium: return UIFont.Weight.medium
            case .semibold: return UIFont.Weight.semibold
            case .bold: return UIFont.Weight.bold
            case .heavy: return UIFont.Weight.heavy
            case .black: return UIFont.Weight.black
            case .italic: return nil
        }
    }
    
    func systemFont(ofSize fontSize: CGFloat) -> UIFont? {
        
        switch self {
            
            case .italic: return UIFont.italicSystemFont(ofSize: fontSize)
            case .bold: return UIFont.boldSystemFont(ofSize: fontSize)
            
            default:
            
                if #available(iOS 8.2, *) {
                    
                    if let weight = weight {
                        return UIFont.systemFont(ofSize: fontSize, weight: weight)
                    }
                }
                
                StyleKit.log("Style kit: System font with style \"\(self)\" is only available on iOS 8.2 or later", onlyOnce: true)
                return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    static func from(rawValue: String?) -> SKFontStyle? {
        guard let rawValue = rawValue?.lowercased() else { return nil }
        
        return SKFontStyle(rawValue: rawValue)
    }
}
