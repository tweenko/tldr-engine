// Feather disable all

/// Returns an array of all valid devices that can be used on the platform.

function InputDeviceEnumerate()
{
    static _array = __InputSystem().__deviceArray;
    return _array;
}