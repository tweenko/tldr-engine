function __InputSwitchXKnownGood()
{
    switch_controller_support_set_defaults();
    switch_controller_set_default_joycon_assignment(switch_controller_joycon_assignment_single);
    
    switch_controller_support_set_player_min(1);
    switch_controller_support_set_player_max(INPUT_MAX_PLAYERS);
    
    if (__INPUT_SWITCH_JOYCON_HORIZONTAL_HOLDTYPE)
    {
        switch_controller_joycon_set_holdtype(switch_controller_joycon_holdtype_horizontal);
        switch_controller_set_supported_styles(switch_controller_handheld
                                             | switch_controller_joycon_left
                                             | switch_controller_joycon_right
                                             | switch_controller_joycon_dual
                                             | switch_controller_pro_controller);
    }
    else
    {
        switch_controller_joycon_set_holdtype(switch_controller_joycon_holdtype_vertical);
        switch_controller_set_supported_styles(switch_controller_handheld
                                             | switch_controller_joycon_left
                                             | switch_controller_joycon_right);
    }
}