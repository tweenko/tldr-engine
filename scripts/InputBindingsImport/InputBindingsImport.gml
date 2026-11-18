// Feather disable all

/// Restores bindings from a struct created by `InputBindingsExport()`.
/// 
/// N.B. Care should be taken not to change export names between savefile versions or the library
///      will not be able to import old bindings from savefiles.
/// 
/// @param {Bool} forGamepad
/// @param {Struct} data
/// @param {Real} [playerIndex=0]

function InputBindingsImport(_forGamepad, _data, _playerIndex = 0)
{
    static _playerArray = __InputSystemPlayerArray();
    static _verbCount   = __InputSystem().__verbCount;
    
    __INPUT_VALIDATE_PLAYER_INDEX
    
    if (not is_struct(_data))
    {
        __InputError("`data` parameter must be a struct created by `InputBindingsExport()`.");
    }
    
    var _bindingArray = _forGamepad? _playerArray[_playerIndex].__gamepadBindingArray : _playerArray[_playerIndex].__kbmBindingArray;
    var _i = 0;
    repeat(_verbCount)
    {
        var _exportName = InputVerbGetExportName(_i);
        if (_exportName != undefined)
        {
            var _alternates = _data[$ _exportName];
            _alternates = is_array(_alternates)? variable_clone(_alternates) : [];
            
            var _j = 0;
            repeat(array_length(_alternates))
            {
                var _binding = _alternates[_j];
                if (_binding != undefined)
                {
                    var _isValidBindingType = (_forGamepad == __InputGamepadBindingIsValid(_binding));
                    if ((not is_numeric(_binding)) || (not _isValidBindingType))
                    {
                        // We check for a valid binding type but do not
                        // full validate keyboard and mouse bindings as 
                        // user rebinding may throw false negatives
                        __InputError("Invalid ", _forGamepad? "gamepad" : "non-gamepad", " binding for verb \"", _exportName, "\": alternate \"", _j, "\", binding value \"", _binding, "\"");
                    }
                }

                ++_j;
            }

            _bindingArray[@ _i] = _alternates;
        }
        
        ++_i;
    }
}