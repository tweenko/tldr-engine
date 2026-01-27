if mode == TEXT_HPCHANGE_MODE.ENEMY || mode == TEXT_HPCHANGE_MODE.PARTY || mode == TEXT_HPCHANGE_MODE.PERCENTAGE {
    while instance_place(x+9, y+6, o_text_hpchange)
        y += 22
}

visible = true
visual_x = x
visual_y = y

x += 9; y += 6

if mode == 3 || mode == 4 {
	var a = animate(.1, 1.5, 6, anime_curve.quad_out, id, "stretch", false)
        a._add(1, 4, anime_curve.linear)
        a._start()
	
    var b = animate(60, -6, 6, anime_curve.linear, id, "xoff", false)
        b._add(6, 4, anime_curve.linear)
        b._start()
}
else {
    animate(visual_x - 6, visual_x - 6 + 15, 10, anime_curve.linear, id, "visual_x")
    animate(visual_y - 14, visual_y + 6, 20, anime_curve.bounce_out, id, "visual_y")
    animate(.2, 1, 3, anime_curve.linear, id, "stretch")
}

alarm[1] = 30