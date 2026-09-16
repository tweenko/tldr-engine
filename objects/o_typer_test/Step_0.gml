if keyboard_check_pressed(ord("L")) && !global.console {
    loc_switch_lang(, false);
    
    t.destroy();
    event_user(0);
}