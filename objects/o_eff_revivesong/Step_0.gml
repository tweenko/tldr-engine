timer ++;

if (timer >= timer_event_descent && timer <= (timer_event_descent + 24)) {
    var _ylerp = timer - timer_event_descent;
    var yy = lerp(guipos_y() - 5, y - 40, clamp(_ylerp / 25, 0, 1));
    var _offset = 2.141592653589793;
    
    if timer % 2 == 0 {
        var d = instance_create(o_eff_generic_animation, x + (cos((timer / 3) + _offset) * 15), yy + (sin((timer / 3) + _offset) * 5), depth);
        d.sprite_index = spr_eff_magicstar;
        d.image_speed = 1.5;
        d.image_blend = choose(#FFE04D, #FFB56C);
        
        d = instance_create(o_eff_generic_animation, x - (sin((timer / 3) + _offset) * 15), yy - (cos((timer / 3) + _offset) * 5), depth);
        d.sprite_index = spr_eff_magicstar;
        d.image_speed = 1.5;
        d.image_blend = choose(#FFE04D, #FFB56C);
    }
}