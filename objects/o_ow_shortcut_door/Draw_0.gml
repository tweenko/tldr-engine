var xx = sine(.5, shake)
x += xx


drawer(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha)
dodge_darken_self(drawer)
lighting_darken_self(drawer)

x -= xx