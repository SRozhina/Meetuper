import Foundation
import UIKit

extension NSMutableAttributedString {
    class func create(html: String, with font: UIFont? = nil) -> NSMutableAttributedString {
        let defaultOptions = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        if let unicodedData = html.data(using: .unicode),
            let mutableString = try? NSMutableAttributedString(data: unicodedData,
                                                               options: defaultOptions,
                                                               documentAttributes: nil) {
            if let font = font {
                mutableString.replaceFont(with: font)
            }
            return mutableString
        }
        return NSMutableAttributedString(string: html)
    }
    
    private func replaceFont(with font: UIFont) {
        beginEditing()
        enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, _) in
            if let currentFont = value as? UIFont {
                let newFontDescriptor = currentFont.fontDescriptor
                    .withFamily(font.familyName)
                    .withSymbolicTraits(currentFont.fontDescriptor.symbolicTraits)!
                let newFont = UIFont(descriptor: newFontDescriptor, size: font.pointSize)
                replaceFont(range: range, value: newFont)
            }
        }
        endEditing()
    }
    
    private func replaceFont(range: NSRange, value: UIFont) {
        removeAttribute(.font, range: range)
        addAttribute(.font, value: value, range: range)
    }
}
