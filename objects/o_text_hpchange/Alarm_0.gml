if mode == TEXT_HPCHANGE_MODE.ENEMY || mode == TEXT_HPCHANGE_MODE.PARTY || mode == TEXT_HPCHANGE_MODE.PERCENTAGE {
    while instance_place(x+9, y+6, o_text_hpchange)
        y += 22
}

visible = true
visual_x = x
visual_y = y

visual_x += 45;

x += 9; y += 6

if mode == TEXT_HPCHANGE_MODE.RECRUIT || mode == TEXT_HPCHANGE_MODE.SCALE {
	var a = animate(.1, 1.5, 6, anime_curve.quad_out, id, "stretch", false)
        a._add(1, 4, anime_curve.linear)
        a._start()
	
    var b = animate(60, -6, 6, anime_curve.linear, id, "xoff", false)
        b._add(6, 4, anime_curve.linear)
        b._start()
}
else {
    animate(visual_x - 10, visual_x + 30, 7, anime_curve.linear, id, "visual_x")
    
    var a = anime_begin(visual_y, method(self, function(v) {
        visual_y = v;
    }));
    anime_add(visual_y - 5, 3);
    anime_add(visual_y - 14, 5, anime_curve.cubic_out);
    anime_add(visual_y, 5, anime_curve.cubic_in);
    anime_add(visual_y - 6, 3, anime_curve.cubic_out);
    anime_add(visual_y, 3, anime_curve.cubic_in);
    anime_start(a);
    
    animate(.2, 1, 3, anime_curve.linear, id, "stretch")
}

alarm[1] = 30;