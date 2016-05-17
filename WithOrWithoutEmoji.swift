import Foundation

public extension NSString {
    
    private func _containsAnEmoji() -> Bool {
        // Original Objective-C code by Gabriel Massana https://github.com/GabrielMassana
        // Adapted to Swift 2 by Eric Dejonckheere https://github.com/ericdke
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
    
    public var containsEmoji: Bool {
        var isEmoji = false
        self.enumerateSubstrings(in: NSRange(location: 0, length: self.length),
                                        options: .byComposedCharacterSequences) {
                                        (substring, substringRange, _, stop) in
            if let substring = substring {
                if (substring as NSString)._containsAnEmoji() {
                    isEmoji = true
                    // Stops the enumeration by setting the unsafe pointer to ObjcBool memory value, false by default in the closure parameters, to true.
                    stop[0] = true
                }
            }
        }
        return isEmoji
    }
    
    private func _emojiRanges() -> [NSRange] {
        var emojiRangesArray = [NSRange]()
        self.enumerateSubstrings(in: NSRange(location: 0, length: self.length),
                                        options: NSStringEnumerationOptions.byComposedCharacterSequences) {
                                        (substring, substringRange, _, _) in
            if let substring = substring {
                if (substring as NSString)._containsAnEmoji() {
                    emojiRangesArray.append(substringRange)
                }
            }
        }
        return emojiRangesArray
    }
    
    public func allEmojisFromString() -> [String] {
        let ranges = self._emojiRanges()
        return ranges.map { self.substring(with: $0) }
    }
    
    public func allLettersFromString() -> [String] {
        let emojis = self.allEmojisFromString()
        let charset = NSCharacterSet(charactersIn: emojis.joined(separator: ""))
        return self.components(separatedBy: charset).filter { !$0.isEmpty }
    }
    
    public func stringWithoutEmojis() -> String {
        return self.allLettersFromString().joined(separator: "")
    }
    
    public func stringWithOnlyEmojis() -> String {
        return self.allEmojisFromString().joined(separator: "")
    }
    
    public var emojiCount: Int {
        return self.allEmojisFromString().count
    }
    
}

public extension String {
    
    public var containsEmoji: Bool {
        return (self as NSString).containsEmoji
    }
    
    public func allEmojisFromString() -> [String] {
        return (self as NSString).allEmojisFromString()
    }
    
    public func allLettersFromString() -> [String] {
        return (self as NSString).allLettersFromString()
    }
    
    public func stringWithoutEmojis() -> String {
        return (self as NSString).stringWithoutEmojis()
    }
    
    public func stringWithOnlyEmojis() -> String {
        return (self as NSString).stringWithOnlyEmojis()
    }
    
    public var emojiCount: Int {
        return (self as NSString).emojiCount
    }
    
}