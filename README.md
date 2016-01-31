![](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)

# With Or Without Emojis

A simple Swift String and NSString extension:

- find if the String contains at least one Emoji

- find the number of Emojis in the String

- return the String without the Emojis

- return the String with only the Emojis

- return an Array of the String's Emojis only

- return an Array of the String's letters without the Emojis

As of 2016/01/31, works with all Emojis, including skin fades and country flags.

Works for OS X and iOS: the extension itself imports Foundation, it's necessary for the NSString to String bridging (it doesn't work for Linux yet).

## Usage

Copy the *WithOrWithoutEmojis.swift* file in your Swift project, or copy the content in one of your Swift files.

Adds these properties and methods on `String` and `NSString`:

```
containsEmoji: Bool
emojiCount: Int
stringWithoutEmojis() -> String
stringWithOnlyEmojis() -> String
allLettersFromString() -> [String]
allEmojisFromString() -> [String]
```

## Credit

Inspired by the work of [Gabriel Massana](https://github.com/GabrielMassana), I've adapted to Swift a [method](https://github.com/GabrielMassana/SearchEmojiOnString-iOS/blob/master/SearchEmojiOnString-iOS/NSString%2BEMOEmoji.m#L15) from his Objective-C project, [SearchEmojiOnString-iOS](https://github.com/GabrielMassana/SearchEmojiOnString-iOS), then added a few features to the result.

In my extension, the method named `_containsAnEmoji` is a direct adaptation of Gabriel Massana's Emoji finding Objective-C [method](https://github.com/GabrielMassana/SearchEmojiOnString-iOS/blob/master/SearchEmojiOnString-iOS/NSString%2BEMOEmoji.m#L15) for NSString.

His work is licensed [MIT](https://github.com/GabrielMassana/SearchEmojiOnString-iOS/blob/master/LICENSE.md), and so is [this project](https://github.com/ericdke/WithOrWithoutEmojis/blob/master/LICENSE.md).