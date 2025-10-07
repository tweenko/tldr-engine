if !is_undefined(idle_path) && idle_path_autodir && !encounter_started && !is_in_battle {
    var _xo = sign(x - xprev_real)
    var _d = (sprite_facing_dir == DIR.RIGHT ? 1 : -1)
    
    if _xo != 0
        image_xscale = _xo * _d
}

xprev_real = x