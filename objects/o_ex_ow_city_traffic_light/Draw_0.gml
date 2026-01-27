var swing = 0
if !inst.active {
    siner++
    if (mode == 1) {
        swingtimer++
        if (swingtimer >= 10)
        {
            swingcount++
            swing = swingcount % 4
            if (swing == 0)
                image_angle = 0
            if (swing == 1)
                image_angle = 15
            if (swing == 2)
                image_angle = 0
            if (swing == 3)
                image_angle = -15
            swingtimer = 0
        }
    }
    for (var i = 0; i < 3; i++)
    {
        draw_self()
        draw_sprite_ext(sprite_index, 1, x, y, image_xscale, image_yscale, image_angle, c_white, sin(siner / 4))
        draw_sprite_ext(sprite_index, 2, x, y, image_xscale, image_yscale, image_angle, c_white, sin(2 + siner / 4))
    }
}
else {
    image_angle = 0
    draw_self()
    draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_white, 1)
}