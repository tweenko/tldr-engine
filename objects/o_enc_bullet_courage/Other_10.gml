instance_create(o_eff_generic, x, y, DEPTH_ENCOUNTER.SOUL+100, {
    life: 5,
    sprite_index: spr_enc_bullet_courage_get,
    target_scale: 0.0625 * 3,
    start_scale: 0.0625,
    
    image_xscale: 0.0625,
    image_yscale: 0.0625,
    
    image_blend: c_yellow,
    image_index: 2,
})
repeat(3 + irandom(2)) {
    instance_create(o_eff_sparestar, 38 + irandom(25), 40 + irandom(160), DEPTH_ENCOUNTER.UI - 10, {
        gui: true    
    })
}

o_enc.tp = tp_clamp(o_enc.tp + tp)
o_enc.tp_glow_alpha = 1

instance_destroy()