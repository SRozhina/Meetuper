import Foundation
import UIKit

extension NSMutableAttributedString {
    internal convenience init?(html: String, with font: UIFont? = nil) {
        let defaultOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        guard let unicodedData = html.data(using: .unicode),
              let mutableString = try? NSMutableAttributedString(data: unicodedData,
                                                                 options: defaultOptions,
                                                                 documentAttributes: nil) else {
                                                                
                                                                    self.init(string: html)
                                                                    return
        }
        if let font = font {
            mutableString.replaceFont(with: font)
        }
        self.init(attributedString: mutableString)
    }
    
    private func replaceFont(with font: UIFont) {
        beginEditing()
        enumerateAttribute(NSAttributedString.Key.font, in: NSRange(location: 0, length: self.length)) { (value, range, _) in
            if let currentFont = value as? UIFont {
                let newFontDescriptor = currentFont.fontDescriptor
                    .withFamily(font.familyName)
                    .withSymbolicTraits(currentFont.fontDescriptor.symbolicTraits)!
                let newFont = UIFont(descriptor: newFontDescriptor, size: font.pointSize)
                let fontMetrics = UIFontMetrics(forTextStyle: .body)
                let scaledFont = fontMetrics.scaledFont(for: newFont)
                replaceAttribute(.font, range: range, value: scaledFont)
            }
        }
        endEditing()
    }
    
    private func replaceAttribute(_ attribute: NSAttributedString.Key, range: NSRange, value: Any) {
        removeAttribute(attribute, range: range)
        addAttribute(attribute, value: value, range: range)
    }
}
