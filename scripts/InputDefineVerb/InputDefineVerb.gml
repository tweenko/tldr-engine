// Feather disable all

/// Defines a verb and its default bindings for keyboard+mouse and gamepad. The `exportName`
/// parameter defines the name of the verb when exported with InputBindingsExport().
///
/// N.B. Care should be taken not to change export names between savefile versions or the library
///      will not be able to import old bindings from savefiles etc.
/// 
/// You may use `undefined` for an export name to indicate that a verb should not be exported or
/// imported.
/// 
/// N.B. If a verb has its export name set to `undefined` then it will be problematic if you later
///      decide to allow export. Only set a verb's export name to `undefined` if you are **certain**
///      that it never needs to be exported.
/// 
/// Bindings can be specifed in one of the following ways:
/// 
/// - gp_* constants
/// - vk_* constants
/// - mb_* constants
/// - Single-character strings for keyboard keys e.g. "A"
/// 
/// Bindings can also be specified as an array of bindings e.g. `[vk_up, "W"]`.
/// 
/// @param {Enum.INPUT_VERB,Real} verbIndex
/// @param {String} exportName
/// @param {Any} defaultKbmBinding
/// @param {Any} defaultGamepadBinding
/// @param {Any} [metadata=struct]

function InputDefineVerb(_verbIndex, _exportName, _kbmBinding, _gamepadBinding, _metadata = {})
{
    static _system = __InputSystem();
    
    if (GM_build_type == "run")
    {
        if not (_system.__verbDefineAllowed)
        {
            __InputError("InputDefineVerb() must only be called in __InputConfigVerbs()");
        }
    }
    
    with(_system)
    {
        var _definition = new __InputClassVerbDefinition(_verbIndex, _exportName, _kbmBinding, _gamepadBinding, _metadata);
        
        __verbDefinitionArray[@ _verbIndex] = _definition;
        
        if (_exportName != undefined)
        {
            if (INPUT_RUNNING_FROM_IDE && struct_exists(__verbExportNameDict, _exportName))
            {
                __InputError("Duplicate verb export name: \"", _exportName, "\"");
            }
            
            __verbExportNameDict[$ _exportName] = _definition;
        }
        
        if (array_get_index(__verbDefIndexArray, _verbIndex) < 0)
        {
            array_push(__verbDefIndexArray, _verbIndex);
        }
    }
}