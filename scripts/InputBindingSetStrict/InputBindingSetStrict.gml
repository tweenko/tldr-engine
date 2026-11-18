// Feather disable all

/// Sets a binding for a player, potentially overwriting the binding that was already there. If
/// `forGamepad` is specified, the binding will be set for gamepad devices, otherwise the binding
/// will be set for the keyboard and mouse device (`INPUT_KBM`). The alternate index parameter can
/// be used to set multiple parallel bindings for one verb.
/// 
/// This function, unlike `InputBindingSet()`, will detect if the new binding collides with
/// existing bindings for other verbs/alternates. If there is a binding collision then this
/// function will not set the new binding at all.
/// 
/// @param {Bool} forGamepad
/// @param {Enum.INPUT_VERB,Real} verbIndex
/// @param {Any} binding
/// @param {Real} [alternate=0]
/// @param {Real} [playerIndex=0]

function InputBindingSetStrict(_forGamepad, _verbIndexA, _binding, _alternateA = 0, _playerIndex = 0)
{
    __INPUT_VALIDATE_PLAYER_INDEX
    
    var _collisionArray = InputBindingFindCollisions(_forGamepad, _binding, _verbIndexA, _playerIndex, _alternateA);
    
    if (array_length(_collisionArray) > 0)
    {
        return false;
    }
    
    InputBindingSet(_forGamepad, _verbIndexA, _binding, _alternateA, _playerIndex);
    return true;
}
