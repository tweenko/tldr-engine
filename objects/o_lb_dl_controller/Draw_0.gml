if !surface_exists(surf_overlay)
    surf_overlay = surface_create(640, 480)
if !surface_exists(surf_final)
    surf_final = surface_create(640, 480)

surface_set_target(surf_overlay)
    draw_clear(c_black)

    gpu_set_blendmode(bm_subtract)
    with o_lb_dl_light_source 
        draw_sprite_ext(sprite_index, image_index, x*2, y*2, image_xscale*2, image_yscale*2, image_angle, image_blend, image_alpha)
    
    gpu_set_blendmode(bm_normal)
surface_reset_target()

surface_set_target(surf_final)
    draw_clear_alpha(0,0)
    
    draw_surface_ext(surf_overlay, 0, 0, 1, 1, 0, c_white, 1)
    
    gpu_set_colourwriteenable(true, true, true, false)
    draw_surface_ext(surf_light, 0, 0, 1, 1, 0, c_white, 1)
    gpu_set_colourwriteenable(true, true, true, true)
surface_reset_target()

draw_surface_ext(surf_overlay, 0, 0, .5, .5, 0, c_white, image_alpha)
draw_surface_ext(surf_final, 
    guipos_x(), guipos_y(), 
    .5, .5, 
    0, c_white, image_alpha
)