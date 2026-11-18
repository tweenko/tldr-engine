// Feather disable all

/// Returns a default binding for a player as set by `InputDefineVerb()`.
/// 
/// Useful for reverting to default bindings using `InputBindingSet()`, 
/// `InputBindingSetSafe()`, or `InputBindingSetStrict()`
/// 
/// @param {Bool} forGamepad
/// @param {Enum.INPUT_VERB,Real} verbIndex
/// @param {Real} [alternate=0]
/// @param {Real} [playerIndex=0]

function InputBindingGetDefault(_forGamepad, _verbIndex, _alternate = 0, _playerIndex = 0)
{
    static _verbDefinitionArray = __InputSystem().__verbDefinitionArray;
    static _playerArray = __InputSystemPlayerArray();
    
    __INPUT_VALIDATE_PLAYER_INDEX
    
    with(_playerArray[_playerIndex])
    {
        var _verbDefinition = _verbDefinitionArray[_verbIndex];
        var _defaultAlternateArray = _forGamepad? _verbDefinition.__gamepadBinding : _verbDefinition.__kbmBinding;
        
        if ((_alternate < 0) || (_alternate >= array_length(_defaultAlternateArray))) return undefined;
        return _defaultAlternateArray[_alternate];
    }
}