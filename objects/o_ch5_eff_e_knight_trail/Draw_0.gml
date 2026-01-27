if !instance_exists(target)
    exit
if !surface_exists(surf_knight)
    surf_knight = surface_create(640, 480)
if !surface_exists(surf_ov)
    surf_ov = surface_create(640, 480)
if !surface_exists(surf)
    surf = surface_create(640, 480)

var spr = target.sprite_index
with target
    if hurt > 0 && is_in_battle || run_away && is_in_battle && is_enemy
    	spr = s_hurt

var xx = target.x + target.xoff + sine(1, target.shake) - guipos_x()
var yy = target.y + target.yoff - guipos_y()

surface_set_target(surf_knight)
    draw_clear_alpha(0,0)
    with target
        s_drawer(spr, image_index, 
        	xx*2, yy*2, 
        	image_xscale*2, image_yscale*2, 
        	image_angle, image_blend, image_alpha
        )
surface_reset_target()

surface_set_target(surf_ov)
    draw_clear_alpha(0,0)
    for (var i = 0; i < 90; i += 3) {
        var __xoff = i*2 + sine(5, 6, o_world.frames + i)
        var __yoff = -i*2 + cosine(5, 6, o_world.frames + i)
        draw_surface_ext(surf_knight, __xoff, __yoff, 1, 1, 0, c_white, 1)
    }
surface_reset_target()

surface_set_target(surf)
    draw_clear_alpha(0,0)
    var u_texOverlay = shader_get_uniform(shd_bm_overlay, "texOverlay");
    shader_set(shd_bm_overlay)
        texture_set_stage(1, surface_get_texture(surf_ov))
        shader_set_uniform_i(u_texOverlay, 1);
        draw_surface(application_surface, 0, 0)
    shader_reset()
surface_reset_target()

draw_surface_ext(surf, guipos_x(), guipos_y(), .5, .5, 0, c_white, 1)