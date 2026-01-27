/// @description turn starts
event_inherited()

var inst = instance_create(o_enc_bullet, o_enc.mybox.x, o_enc.mybox.y + 10, DEPTH_ENCOUNTER.BULLETS_INSIDE, {
    inside: true
})

var a = animate(inst.x - 40, inst.x + 40, 60, anime_curve.cubic_in_out, inst, "x", false)
a._add(inst.x - 40, 60, anime_curve.cubic_in_out)
a._start()

anime_set_loop(a, true)