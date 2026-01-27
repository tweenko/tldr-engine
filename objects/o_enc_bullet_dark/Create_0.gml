event_inherited()
image_xscale = .1
image_yscale = image_xscale
glow = 0

homing_target = noone
scale = 1
spd = 0
timer = random(5)

element = "dark_star"
att = 30

image_alpha = 0

_underaura = false
_aura_call = function() {
    _underaura = true
    
    glow += .03
    scale -= .05
    if spd > .2
        spd -= .001
    
    if scale <= .4 {
        instance_destroy()
        instance_create(o_enc_bullet_courage, x, y, depth, {
            direction: point_direction(homing_target.x, homing_target.y, x, y),
            speed: 2,
            friction: .05,

            image_xscale: .5,
            image_yscale: .5,
        })
    }
    
    if o_world.frames % 5 == 0
        instance_create(o_eff_generic, x, y, depth - 10, {
            direction: point_direction(homing_target.x, homing_target.y, x, y) + random_range(-40, 40),
            speed: 1.5,
            friction: .05,
            start_scale: 2,
            target_scale: 1,
        })
}

audio_play(snd_spawn_appear)