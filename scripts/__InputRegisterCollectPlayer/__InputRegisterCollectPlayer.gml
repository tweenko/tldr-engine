// Feather disable all

function __InputRegisterCollectPlayer()
{
    __InputPlugInRegisterCallbackInternal(INPUT_PLUG_IN_CALLBACK.COLLECT_PLAYER, 0, function(_playerIndex)
    {
        static _system             = __InputSystem();
        static _playerArray        = __InputSystemPlayerArray();
        static _verbCount          = _system.__verbCount;
        static _virtualButtonArray = _system.__virtualButtonArray;
        
        with(_playerArray[_playerIndex])
        {
            var _device = __device;
            
            var _connected = __UpdateStatus();
            
            var _valueRawArray   = __valueRawArray;
            var _valueClampArray = __valueClampArray;
            
            if ((not _connected) || __blocked || __ghost || InputDeviceGetRebinding(_device) || (not InputGameHasFocus()) || __InputRestartTimeout())
            {
                array_map_ext(_valueRawArray,   function() { return 0; });
                array_map_ext(_valueClampArray, function() { return 0; });
            }
            else
            {
                if ((_device == INPUT_TOUCH) || (INPUT_MOUSE_CAN_USE_VIRTUAL_BUTTONS && (_device == INPUT_KBM)))
                {
                    //Detect any new touch points and find the top-most button to handle it
                    var _i = 0;
                    repeat(INPUT_MAX_TOUCHPOINTS)
                    {
                        if (device_mouse_check_button_pressed(_i, mb_left))
                        {
                            var _j = 0;
                            repeat(array_length(_virtualButtonArray))
                            {
                                if (_virtualButtonArray[_j].__CaptureTouchpoint(_i)) break;
                                ++_j;
                            }
                        }
                        
                        ++_i;
                    }
                }
                
                if (_device >= 0)
                {
                    ////////////////
                    //            //
                    //  Gamepads  //
                    //            //
                    ////////////////
                    
                    __lastConnectedGamepadType = InputDeviceGetGamepadType(_device);
                    var _hotswapBlocked = false;
                    var _readArray = __InputGamepadGetReadArray(_device);
                    
                    var _minLeft  = __thresholdMinArray[INPUT_THRESHOLD.LEFT ];
                    var _maxLeft  = __thresholdMaxArray[INPUT_THRESHOLD.LEFT ];
                    var _minRight = __thresholdMinArray[INPUT_THRESHOLD.RIGHT];
                    var _maxRight = __thresholdMaxArray[INPUT_THRESHOLD.RIGHT];
                    
                    //Prevent div-by-zero
                    _maxLeft  = max(_minLeft  + math_get_epsilon(), _maxLeft);
                    _maxRight = max(_minRight + math_get_epsilon(), _maxRight);
                    var _deltaLeft  = _maxLeft - _minLeft;
                    var _deltaRight = _maxRight - _minRight;
                    
                    //Precalute coefficients to apply to axis inputs
                    var _leftH = _readArray[gp_axislh - INPUT_GAMEPAD_BINDING_MIN](_device, gp_axislh);
                    var _leftV = _readArray[gp_axislv - INPUT_GAMEPAD_BINDING_MIN](_device, gp_axislv);
                    var _leftDist = sqrt(_leftH*_leftH + _leftV*_leftV);
                    var _leftCoeff = clamp((_leftDist - _minLeft) / _deltaLeft, 0.0, 1.0) / _leftDist;
                    
                    _leftH    *= _leftCoeff;
                    _leftV    *= _leftCoeff;
                    _leftDist *= _leftCoeff;
                    
                    var _rightH = _readArray[gp_axisrh - INPUT_GAMEPAD_BINDING_MIN](_device, gp_axisrh);
                    var _rightV = _readArray[gp_axisrv - INPUT_GAMEPAD_BINDING_MIN](_device, gp_axisrv);
                    var _rightDist = sqrt(_rightH*_rightH + _rightV*_rightV);
                    var _rightCoeff = clamp((_rightDist - _minRight) / _deltaRight, 0.0, 1.0) / _rightDist;
                    
                    _rightH    *= _rightCoeff;
                    _rightV    *= _rightCoeff;
                    _rightDist *= _rightCoeff;
                    
                    var _bindingArray = __gamepadBindingArray;
                    var _i = 0;
                    repeat(_verbCount)
                    {
                        var _valueRaw   = 0;
                        var _valueClamp = 0;
                        
                        //Iterate over all our bindings to see if any buttons/axes are being held down
                        var _alternateArray = _bindingArray[_i];
                        var _j = 0;
                        repeat(array_length(_alternateArray))
                        {
                            var _rawBinding = _alternateArray[_j];
                            if (_rawBinding != undefined)
                            {
                                var _sign = sign(_rawBinding);
                                var _absBinding = abs(_rawBinding);
                                
                                //Avoid fetching thumbstick state again and instead use cached values
                                if (_absBinding == gp_axislh)
                                {
                                    if (_leftDist > _valueRaw)
                                    {
                                        _valueClamp = (_sign*_leftH > __INPUT_THUMBSTICK_OVERLAP_FACTOR*abs(_leftV))? _leftDist : 0;
                                        _valueRaw = max(0, _sign*_leftH);
                                    }
                                }
                                else if (_absBinding == gp_axislv)
                                {
                                    if (_leftDist > _valueRaw)
                                    {
                                        _valueClamp = (_sign*_leftV > __INPUT_THUMBSTICK_OVERLAP_FACTOR*abs(_leftH))? _leftDist : 0;
                                        _valueRaw = max(0, _sign*_leftV);
                                    }
                                }
                                else if (_absBinding == gp_axisrh)
                                {
                                    if (_rightDist > _valueRaw)
                                    {
                                        _valueClamp = (_sign*_rightH > __INPUT_THUMBSTICK_OVERLAP_FACTOR*abs(_rightV))? _rightDist : 0;
                                        _valueRaw = max(0, _sign*_rightH);
                                    }
                                }
                                else if (_absBinding == gp_axisrv)
                                {
                                    if (_rightDist > _valueRaw)
                                    {
                                        _valueClamp = (_sign*_rightV > __INPUT_THUMBSTICK_OVERLAP_FACTOR*abs(_rightH))? _rightDist : 0;
                                        _valueRaw = max(0, _sign*_rightV);
                                    }
                                }
                                else
                                {
                                    //Other input types need to get state from the gamepad
                                    
                                    var _raw = _sign*_readArray[_absBinding - INPUT_GAMEPAD_BINDING_MIN](_device, _absBinding);
                                    if (_raw > _valueRaw)
                                    {
                                        if ((_absBinding == gp_shoulderlb) || (_absBinding == gp_shoulderrb))
                                        {
                                            _valueClamp = clamp((_raw - INPUT_GAMEPAD_TRIGGER_MIN_THRESHOLD) / (INPUT_GAMEPAD_TRIGGER_MAX_THRESHOLD - INPUT_GAMEPAD_TRIGGER_MIN_THRESHOLD), 0, 1);
                                            _valueRaw = _raw;
                                        }
                                        else
                                        {
                                            _valueClamp = (_raw > 0);
                                            _valueRaw = _raw;
                                            
                                            _hotswapBlocked = true; //Block hotswap on a button
                                        }
                                    }
                                }
                            }
                            
                            ++_j;
                        }
                        
                        _valueRawArray[@   _i] = _valueRaw;
                        _valueClampArray[@ _i] = _valueClamp;
                        
                        ++_i;
                    }
                    
                    __hotswapBlocked = _hotswapBlocked;
                }
                else if (_device == INPUT_KBM)
                {
                    ////////////////////////
                    //                    //
                    //  Keyboard & Mouse  //
                    //                    //
                    ////////////////////////
                    
                    var _bindingArray = __kbmBindingArray;
                    
                    if (INPUT_MOUSE_CAN_USE_VIRTUAL_BUTTONS)
                    {
                        //Reset values for each verb. We'll handle pressed/held/released after updating virtual buttons
                        array_map_ext(_valueClampArray, function() { return 0; });
                        array_map_ext(_valueRawArray,   function() { return 0; });
                        
                        //Update virtual buttons
                        var _i = 0;
                        repeat(array_length(_virtualButtonArray))
                        {
                            _virtualButtonArray[_i].__Collect(_valueRawArray, _valueClampArray);
                            ++_i;
                        }
                        
                        var _i = 0;
                        repeat(_verbCount)
                        {
                            //Iterate over all our bindings to see if any keys are being held down
                            var _newHeld = false;
                            
                            var _alternateArray = _bindingArray[_i];
                            var _j = 0;
                            repeat(array_length(_alternateArray))
                            {
                                var _binding = _alternateArray[_j];
                                if (_binding != undefined)
                                {
                                    if ((_binding == mb_left)
                                    || (_binding == mb_middle)
                                    || (_binding == mb_right)
                                    || (_binding == mb_side1)
                                    || (_binding == mb_side2))
                                    {
                                        if (mouse_check_button(_binding)) _newHeld = true;
                                    }
                                    else if (_binding == mb_wheel_up)
                                    {
                                        if (mouse_wheel_up()) _newHeld = true;
                                    }
                                    else if (_binding == mb_wheel_down)
                                    {
                                        if (mouse_wheel_down()) _newHeld = true;
                                    }
                                    else
                                    {
                                        if (keyboard_check(_binding)) _newHeld = true;
                                    }
                                }
                                
                                ++_j;
                            }
                            
                            if (_newHeld)
                            {
                                _valueRawArray[@   _i] = 1;
                                _valueClampArray[@ _i] = 1;
                            }
                            
                            ++_i;
                        }
                    }
                    else
                    {
                        var _i = 0;
                        repeat(_verbCount)
                        {
                            //Iterate over all our bindings to see if any keys are being held down
                            var _newHeld = false;
                            
                            var _alternateArray = _bindingArray[_i];
                            var _j = 0;
                            repeat(array_length(_alternateArray))
                            {
                                var _binding = _alternateArray[_j];
                                if (_binding != undefined)
                                {
                                    if ((_binding == mb_left)
                                    ||  (_binding == mb_middle)
                                    ||  (_binding == mb_right)
                                    ||  (_binding == mb_side1)
                                    ||  (_binding == mb_side2))
                                    {
                                        if (mouse_check_button(_binding)) _newHeld = true;
                                    }
                                    else if (_binding == mb_wheel_up)
                                    {
                                        if (mouse_wheel_up()) _newHeld = true;
                                    }
                                    else if (_binding == mb_wheel_down)
                                    {
                                        if (mouse_wheel_down()) _newHeld = true;
                                    }
                                    else
                                    {
                                        if (keyboard_check(_binding)) _newHeld = true;
                                    }
                                }
                                
                                ++_j;
                            }
                            
                            if (_newHeld)
                            {
                                _valueRawArray[@   _i] = 1;
                                _valueClampArray[@ _i] = 1;
                            }
                            else
                            {
                                _valueRawArray[@   _i] = 0;
                                _valueClampArray[@ _i] = 0;
                            }
                            
                            ++_i;
                        }
                    }
                }
                else if (_device == INPUT_TOUCH)
                {
                    ///////////////////
                    //               //
                    //  Touchscreen  //
                    //               //
                    ///////////////////
                    
                    //Reset values for each verb. We'll handle pressed/held/released after updating virtual buttons
                    array_map_ext(_valueClampArray, function() { return 0; });
                    array_map_ext(_valueRawArray,   function() { return 0; });
                    
                    //Update virtual buttons
                    var _i = 0;
                    repeat(array_length(_virtualButtonArray))
                    {
                        _virtualButtonArray[_i].__Collect(_valueRawArray, _valueClampArray);
                        ++_i;
                    }
                }
            }
        }
    });
}
