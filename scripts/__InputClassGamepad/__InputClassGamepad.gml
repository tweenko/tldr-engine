// Feather disable all

/// @param gamepadIndex

function __InputClassGamepad(_gamepadIndex) constructor
{
    static _genericReadArray = __InputSystem().__genericReadArray;
    
    __gamepadIndex      = _gamepadIndex;
    __blocked           = false;
    __lastConnectedTime = current_time;
    
    __guid    = undefined;
    __vendor  = "";
    __product = "";
    
    __description = "Generic Gamepad";
    __type        = INPUT_GAMEPAD_TYPE_XBOX;
    __xinput      = false;
    
    __xinput            = false;
    __steamHandle       = undefined;
    __steamHandleIndex  = undefined;

    __readArray = variable_clone(_genericReadArray, 1);
    __activityScanIndex = 0;
    __active = false;
    
    __prevActivityArray = array_create(6, false); // [gp_axislh, gp_axislv, gp_axisrh, gp_axisrv, gp_shoulderlb, gp_shoulderrb]
    
    
    
    static __UpdateActivity = function()
    {
        var _gamepadIndex      = __gamepadIndex;
        var _prevActivityArray = __prevActivityArray; //Axes only
        
        __active = false;
        
        if (INPUT_BAN_GAMEPADS || __blocked || (not gamepad_is_connected(_gamepadIndex)))
        {
            _prevActivityArray[@ 0] = false;
            _prevActivityArray[@ 1] = false;
            _prevActivityArray[@ 2] = false;
            _prevActivityArray[@ 3] = false;
            _prevActivityArray[@ 4] = false;
            _prevActivityArray[@ 5] = false;
            return;
        }
        
        var _axisIndexTriggerOffset = (gp_axisrv - gp_axislh) + 1;
        
        var _index     = __activityScanIndex;
        var _readArray = __readArray;
        
        repeat(3) //Only scan a few bindings every frame to reduce the workload
        {
            _index = (_index + 1) mod INPUT_GAMEPAD_BINDING_COUNT;
            
            var _binding = _index + INPUT_GAMEPAD_BINDING_MIN;
            var _value = _readArray[_binding - INPUT_GAMEPAD_BINDING_MIN](_gamepadIndex, _binding);
            
            if ((_binding == gp_axislh) || (_binding == gp_axislv) || (_binding == gp_axisrh) || (_binding == gp_axisrv))
            {
                if (INPUT_GAMEPAD_THUMBSTICK_REPORTS_ACTIVE)
                {
                    var _bindingActive = (abs(_value) > INPUT_GAMEPAD_THUMBSTICK_MIN_THRESHOLD);
                    
                    if ((not _prevActivityArray[_binding - gp_axislh]) && _bindingActive)
                    {
                        __active = true;
                    }
                    
                    _prevActivityArray[@ _binding - gp_axislh] = _bindingActive;
                }
            }
            else if ((_binding == gp_shoulderlb) || (_binding == gp_shoulderrb))
            {
                if (INPUT_GAMEPAD_TRIGGER_REPORTS_ACTIVE)
                {
                    var _bindingActive = (_value > INPUT_GAMEPAD_TRIGGER_MIN_THRESHOLD);
                    
                    if ((not _prevActivityArray[_axisIndexTriggerOffset + (_binding - gp_shoulderlb)]) && _bindingActive)
                    {
                        __active = true;
                    }
                    
                    _prevActivityArray[@ _axisIndexTriggerOffset + (_binding - gp_shoulderlb)] = _bindingActive;
                }
            }
            else 
            {
                if (_value > 0)
                {
                    __active = true;
                }
            }
        }
        
        __activityScanIndex = _index;
    }
}