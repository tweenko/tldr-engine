if timer == 0
    instance_create(o_eff_snowflake, x - 12, y - 10, depth + 5)
if timer == 3
    instance_create(o_eff_snowflake, x + 12, y - 10, depth + 5)
if timer == 6
    instance_create(o_eff_snowflake, x, y + 10, depth + 5)

if timer == 9 {
    with (o_eff_snowflake) {
        for (var i = 0; i < 6; i ++) {
            var inst = instance_create(o_eff_snowflake, x, y, depth + 5)
            inst.direction = 60 * i
            inst.speed = 4
            inst.friction = .2
            inst.image_xscale = .37
            inst.image_yscale = .37
            inst.rot = random(5)
        }
        instance_destroy()
    }
}

if timer == 14 {
    instance_destroy()
}

timer ++