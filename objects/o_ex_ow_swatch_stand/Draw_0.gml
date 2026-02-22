var xx = sine(.5, shake)
x += xx

s_drawer(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
dodge_darken_self(s_drawer)
lighting_darken_self(s_drawer)

x -= xx