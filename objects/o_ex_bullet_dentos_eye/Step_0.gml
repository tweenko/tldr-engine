image_angle = lerp(image_angle, 0, .15)
image_blend = merge_color(c_red, c_red, min(1, shake/3))

if timer < 30
    image_xscale = lerp(image_xscale, 1, .2)

if timer > 30 && shake < 3
    shake += 2

if shake >= 3 && spawned < 6 && timer % 2 == 0 {
    var rad = 4
    var dir = spawned * 360/6
    
    instance_create(o_ex_bullet_dentos_diamond, 
        x + lengthdir_x(rad, dir), y + lengthdir_y(rad, dir),
        depth + 10, 
        {
            direction: dir,
            image_angle: dir + 90
        }
    )
    audio_play(snd_crow, 0, 1, 1 + .2 * spawned)
    
    spawned ++        
}
if spawned > 3
    image_xscale -= .02

if shake > 0
    instance_create(o_eff_generic, x + random_range(-10, 10), y + random_range(-10, 10), depth + 10, {
        direction: random(360),
        speed: .2,
        life: 10,
        friction: -.2,
        
        image_alpha: .5,
        image_blend,
    })

if image_xscale <= 0
    instance_destroy()

timer ++