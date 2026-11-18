// Feather disable all

/// "Consumes" a verb, causing it to be immediately deactivated and return a value of zero until
/// the verb is retriggered (e.g. by released a keyboard key and pressed it again). This helpful
/// when navigating menus to prevent multiple inputs.
/// 
/// @param {Enum.INPUT_VERB,Real} verbIndex
/// @param {Real} [playerIndex=0]

function InputVerbConsume(_verbIndex, _playerIndex = 0)
{
    static _verbToClusterMap = __InputSystem().__verbToClusterMap;
    static _playerArray      = __InputSystemPlayerArray();
    
    __INPUT_VALIDATE_PLAYER_INDEX
    
    with(_playerArray[_playerIndex])
    {
        __InputVerbConsumeInternal(self, _verbIndex, false);
        
        //Update clusters associated with this verb
        var _verbToClusterArray = _verbToClusterMap[? _verbIndex];
        if (is_array(_verbToClusterArray))
        {
            var _i = 0;
            repeat(array_length(_verbToClusterArray))
            {
                __UpdateCluster(_verbToClusterArray[_i]);
                ++_i;
            }
        }
    }
}

function __InputVerbConsumeInternal(_playerStruct, _verbIndex, _ignoreHeldCheck)
{
    with(_playerStruct)
    {
        var _verbState = __verbStateArray[_verbIndex];
        if ((_ignoreHeldCheck || _verbState.__held) && (array_get_index(__consumedArray, _verbState) < 0))
        {
            array_push(__consumedArray, _verbState);
        }
        
        with(_verbState)
        {
            __prevHeld   = false;
            __held       = false;
            __valueRaw   = 0;
            __valueClamp = 0;
            __pressFrame = -infinity;
        }
    }
}