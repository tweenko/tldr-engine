timer ++
radius = lerp(radius, radius_goal, .1)

image_xscale = (radius + 4) / 20
image_yscale = image_xscale

var __list = instance_place_list_ext(x, y, o_enc_bullet_dark, false)
for (var i = 0; i < array_length(__list); i ++) {
    __list[i]._aura_call()
}