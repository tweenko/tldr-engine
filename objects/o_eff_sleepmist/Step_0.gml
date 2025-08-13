siner ++

if siner >= 3 && siner <= 24 {
    if success {
        var inst = instance_create(o_eff_snowflake, x - 25 + random(50), y - 25 + random(50), depth - 10)
        inst.rot = random(5)
        inst.image_xscale = .25
        inst.image_yscale = .25
    }
}
if siner >= 40 {
    instance_destroy()
}