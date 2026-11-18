// Feather disable all

/// @param {Enum.INPUT_THRESHOLD,Real} thresholdType
/// @param {Real} value
/// @param {Real} [playerIndex=0]

function InputPlayerSetMinThreshold(_thresholdType, _value, _playerIndex = 0)
{
    static _playerArray = __InputSystemPlayerArray();
    
    __INPUT_VALIDATE_PLAYER_INDEX
    
    with(_playerArray[_playerIndex])
    {
        if (_thresholdType == INPUT_THRESHOLD.BOTH)
        {
            __SetMinThreshold(INPUT_THRESHOLD.LEFT,  _value);
            __SetMinThreshold(INPUT_THRESHOLD.RIGHT, _value);
            __SetMinThreshold(INPUT_THRESHOLD.BOTH,  _value);
        }
        else
        {
            __SetMinThreshold(_thresholdType, _value);
            __SetMinThreshold(INPUT_THRESHOLD.BOTH, 0.5*(__thresholdMinArray[INPUT_THRESHOLD.LEFT] + __thresholdMinArray[INPUT_THRESHOLD.RIGHT]));
        }
    }
}