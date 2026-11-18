// Feather disable all

/// @param binding

function __InputGamepadBindingIsValid(_binding)
{
    if (is_numeric(_binding))
    {
        if (__InputBindingIsThumbstick(_binding))
        {
            return true;
        }
        else if ((_binding >= INPUT_GAMEPAD_BINDING_MIN) 
             &&  (_binding <= INPUT_GAMEPAD_BINDING_MAX))
        {
            return true;
        }
    }

    return false;
}
