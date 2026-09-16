#macro TYPER_CONSIDER_SPACES [" ", "　"]
#macro TYPER_PUNCTUATION_SHORT [",", "゠", "、"]
#macro TYPER_PUNCTUATION_LONG [".", "!", "?", "…", "？", "。", "・", "！", "゠"]
#macro TYPER_CONSIDER_SMALL_KANA ["ぁ", "ぃ", "ぅ", "ぇ", "ぉ", "ァ", "ィ", "ゥ", "ェ", "ォ", "ゃ", "ゅ", "ょ", "ャ", "ュ", "ョ", "っ", "ッ", "ヶ", "ゕ", "ヵ"]

#macro TYPER_CONSIDER_OPENING_BRACKET ["（", "「", "『", "【", "〔", "〖", "(", "[", "{"]
#macro TYPER_CONSIDER_CLOSING_BRACKET ["）", "」", "』", "】", "〕", "〗", ")", "]", "}"]

/// @desc returns whether a given symbol should be considered a type of whitespace
function __typer_symbol_is_space(_symbol) {
    return array_contains(TYPER_CONSIDER_SPACES, _symbol);
}
/// @desc returns whether a given symbol should be considered punctuation
function __typer_symbol_is_punctuation(_symbol) {
    return array_contains(TYPER_PUNCTUATION_SHORT, _symbol) 
        || array_contains(TYPER_PUNCTUATION_LONG, _symbol) 
        || array_contains(TYPER_CONSIDER_CLOSING_BRACKET, _symbol);
}