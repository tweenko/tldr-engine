if !surface_exists(surf) 
    surf = surface_create(sprite_width, sprite_height)

var off = -o_world.frames/2

surface_set_target(surf)
draw_sprite_tiled(spr_ex_ow_church_groundbg, 0, off, off)
surface_reset_target()

draw_surface_ext(surf, x, y, 1, 1, 0, c_white, 1)