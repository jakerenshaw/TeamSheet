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
    
    // MARK: - UIButton -
    /**
        Applies style to a button
     
        - parameter button: Button view to apply style to
        - parameter title: Title to set
        - parameter forState: Control state for which to set style
    */
    func apply(button: UIButton?, title: String?, forState state: UIControl.State) {
        
        apply(control: button)
        
        if button?.buttonType != UIButton.ButtonType.custom {
            StyleKit.log("Style kit warning: style support for non custom button types is limited, consider changing button type to custom", onlyOnce: true)
        }
        
        if let _ = textAlignment {
            StyleKit.log("Style kit warning: textAlignment have no effect on UIButton, use contentHorizontalAlignment instead", onlyOnce: true)
        }
        
        if !checkFlag(flagLabelWasSet) {
            setLabelFlags()
        }
        
        guard checkFlag(flagLabelAny) else {
            
            button?.sk_setTitleWithoutStyleApplication(title, forState: state)
            return
        }
        
        // Set style using attributed string
        let styledTitle = StyleKit.string(withStyle: self, string: title, defaultParagraphStyle: button?.sk_defaultParagraphStyle())
        button?.setAttributedTitle(styledTitle, for: state)
    }
}
