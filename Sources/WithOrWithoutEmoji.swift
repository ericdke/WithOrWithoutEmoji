import Foundation

public extension NSString {
    
    private func _containsAnEmoji() -> Bool {
        // Original Objective-C code by Gabriel Massana https://github.com/GabrielMassana
        // Adapted to Swift 3 by Eric Dejonckheere https://github.com/ericdke
        let hs = self.character(at: 0)
        // surrogate pair
        if 0xd800 <= hs && hs <= 0xdbff {
            if self.length > 1 {
                let ls = self.character(at: 1)
                let uc:Int = Int(((hs - 0xd800) * 0x400) + (ls - 0xdc00)) + 0x10000
                if 0x1d000 <= uc && uc <= 0x1f9c0 {
                    return true
                }
            }
        } else if self.length > 1 {
            let ls = self.character(at: 1)
            if ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c {
                return true
            }
        } else {
            // non surrogate
            if  (0x2100 <= hs && hs <= 0x27ff) ||
                (0x2b05 <= hs && hs <= 0x2b07) ||
                (0x2934 <= hs && hs <= 0x2935) ||
                (0x3297 <= hs && hs <= 0x3299)
            {
                return true
            } else if   hs == 0xa9   ||
                hs == 0xae   ||
                hs == 0x303d ||
                hs == 0x3030 ||
                hs == 0x2b55 ||
                hs == 0x2b1c ||
                hs == 0x2b1b ||
                hs == 0x2b50
            {
                return true
            }
        }
        return false
    }
    
}

public extension String {
    
    public var condensedWhitespace: String {
        #if os(OSX)
            let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        #else
            let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines())
        #endif
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    public var emojiRanges: [NSRange] {
        var emojiRangesArray = [NSRange]()
        let s = NSString(string:self)
        s.enumerateSubstrings(in: NSRange(location: 0, length: s.length),
                              options: .byComposedCharacterSequences) {
                                (substring, substringRange, _, _) in
                                if let substring = substring {
                                    let sub = NSString(string:substring)
                                    if sub._containsAnEmoji() {
                                        emojiRangesArray.append(substringRange)
                                    }
                                }
        }
        return emojiRangesArray
    }
    
    public var containsEmoji: Bool {
        var isEmoji = false
        let s = NSString(string:self)
        s.enumerateSubstrings(in:
            NSRange(location: 0, length: s.length),
                              options: .byComposedCharacterSequences) {
                                (substring, substringRange, _, stop) in
                                if let substring = substring {
                                    let sub = NSString(string:substring)
                                    if sub._containsAnEmoji() {
                                        isEmoji = true
                                        // Stops the enumeration by setting the unsafe pointer to ObjcBool memory value, false by default in the closure parameters, to true.
                                        stop[0] = true
                                    }
                                }
        }
        return isEmoji
    }
    
    public var emojisWithoutLetters: [String] {
        let s = NSString(string:self)
        return self.emojiRanges.map { s.substring(with: $0) }
    }
    
    public var lettersWithoutEmojis: [String] {
        #if os(OSX)
            var charSet = CharacterSet()
            charSet.insert(charactersIn: self.emojisWithoutLetters.joined(separator: ""))
        #else
            let charSet = NSCharacterSet(charactersIn: self.emojisWithoutLetters.joined(separator: ""))
        #endif
        let wo = self.components(separatedBy: charSet).joined(separator: "")
        return wo.characters.map { String($0) }.filter { $0 != "" }
    }
    
    public var condensedLettersWithoutEmojis: [String] {
        return self.lettersWithoutEmojis.filter { !$0.isEmpty && $0 != " " }
    }
    
    public var withoutEmojis: String {
        return self.lettersWithoutEmojis.joined(separator: "")
    }
    
    public var condensedStringWithoutEmojis: String {
        return self.lettersWithoutEmojis.joined(separator: "").condensedWhitespace
    }
    
    public var onlyEmojis: String {
        return self.emojisWithoutLetters.joined(separator: "")
    }
    
    public var emojiCount: Int {
        return self.emojisWithoutLetters.count
    }
    
}
