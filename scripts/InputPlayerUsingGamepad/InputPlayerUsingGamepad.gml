// Feather disable all

/// Returns whether a player has been assigned a gamepad as their device. If the optional
/// `complianceSafe` argument is set to `true` (which it is by default) then this function will
/// always return `true` when running on console.
/// 
/// @param {Real} [playerIndex=0]
/// @param {Boolean} [complianceSafe=true]

function InputPlayerUsingGamepad(_playerIndex = 0, _complianceSafe = true)
{
    static _playerArray = __InputSystemPlayerArray();
    
    if (INPUT_ON_CONSOLE && _complianceSafe)
    {
        return true;
    }
    
    __INPUT_VALIDATE_PLAYER_INDEX
    
    return InputDeviceIsGamepad(_playerArray[_playerIndex].__device);
}