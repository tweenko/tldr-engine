enum TEXT_HPCHANGE_MODE {
    PARTY = 0, 
    ENEMY = 1,
    PERCENTAGE = 2, 
    RECRUIT = 3,
    SCALE = 4
}

draw = 1
mode = TEXT_HPCHANGE_MODE.PARTY
user = "kris"

/// @desc converts text from the `draw` variable into a localized sprite
__draw_to_sprite = function(_draw, _fallback = loc_sprite("damage_miss")) {
    // account for edge cases
    if mode == TEXT_HPCHANGE_MODE.RECRUIT 
        _draw = "recruit";
    else if _draw == "+100%"
        _draw = "100";
    
    var potential_spr = loc_sprite($"damage_{_draw}");
    if sprite_exists(potential_spr)
        return potential_spr;
    
    return _fallback;
}

stretch = .2
xoff = 0
align = 0 // 1 for right

visual_x = x
visual_y = y

// adjust the position to be rendered on the gui layer
x -= guipos_x()
y -= guipos_y()
x *= 2
y *= 2
depth = -2000 - instance_number(object_index)

alarm[0] = 1 // animate
visible = false