// Feather disable all

/// @param binding

function __InputKbmBindingIsValid(_binding)
{
    if (is_numeric(_binding))
    {
        if ((_binding == mb_left)
         || (_binding == mb_middle)
         || (_binding == mb_right)
         || (_binding == mb_side1)
         || (_binding == mb_side2)
         || (_binding == mb_wheel_up)
         || (_binding == mb_wheel_down))
        {
            return true;
        }
        else if ((_binding >= INPUT_KEYCODE_MIN)
             &&  (_binding <  0xFF))
        {
            // We check an upper bound for developer-defined bindings that is lower 
            // than INPUT_KEYCODE_MAX (used for player-defined bindings) to prevent
            // problematic defaults and avoid overlap with gamepad constant indexes
            return true;
        }
    }

    return false;
}
