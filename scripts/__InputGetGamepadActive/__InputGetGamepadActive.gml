// Feather disable all

function __InputGetGamepadActive(_device)
{
    static _gamepadArray = __InputSystem().__gamepadArray;
    
    if (INPUT_BAN_GAMEPADS) return false;
    if (_device < 0) return false;
    if (not InputGameHasFocus()) return false;
    if (not InputDeviceIsConnected(_device)) return false;
    if (not gamepad_is_connected(_device)) return false;
    return _gamepadArray[_device].__active;
}