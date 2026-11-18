// Feather disable all

/// @param {Enum.INPUT_THRESHOLD,Real} thresholdType
/// @param {Real} value
/// @param {Real} [playerIndex=0]

function InputPlayerSetMaxThreshold(_thresholdType, _value, _playerIndex = 0)
{
    static _playerArray = __InputSystemPlayerArray();
    
    __INPUT_VALIDATE_PLAYER_INDEX
    
    with(_playerArray[_playerIndex])
    {
        if (_thresholdType == INPUT_THRESHOLD.BOTH)
        {
            __SetMaxThreshold(INPUT_THRESHOLD.LEFT,  _value);
            __SetMaxThreshold(INPUT_THRESHOLD.RIGHT, _value);
            __SetMaxThreshold(INPUT_THRESHOLD.BOTH,  _value);
        }
        else
        {
            __SetMaxThreshold(_thresholdType, _value);
            __SetMaxThreshold(INPUT_THRESHOLD.BOTH, 0.5*(__thresholdMaxArray[INPUT_THRESHOLD.LEFT] + __thresholdMaxArray[INPUT_THRESHOLD.RIGHT]));
        }
    }
}