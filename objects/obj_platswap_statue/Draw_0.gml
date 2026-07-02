var xx = sine(.5, shake)
x += xx
//

//Depth
if global.platforming_perspective>0 depth = DEPTH_PLATFORMER.BACK2

//Draw back light
shinetimer++
var ssx = 1.35 + (0.15 * sin(shinetimer * 0.03))
var ssy = 1.35 + (0.15 * cos(shinetimer * 0.015))
if global.platforming_perspective>0.5 and can_hit {shinealpha += 0.1} else {shinealpha -= 0.1}
shinealpha = clamp(shinealpha, 0, 1)
draw_sprite_ext(spr_platswap_statue_light, 0, x, y, ssx/2, ssy/2, 0, c_lime, shinealpha * global.platforming_perspective * (0.5 + (0.15 * sin(shinetimer * 0.02))));

//Draw the statue
pal_index = wrap02(pal_index + 0.2, 0, 6)
if !can_hit pal_index = 7
pal_swap_set(pal_sprite, pal_index, false)
draw_sprite(sprite_index, lerp(0, (sprite_get_number(sprite_index)-0.001), global.platforming_perspective), x, y)
pal_swap_reset()

//
x -= xx