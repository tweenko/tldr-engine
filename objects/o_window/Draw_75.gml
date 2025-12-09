if global.border {
    if !surface_exists(surf_border)
        surf_border = surface_create(960, 540)
    surface_set_target(surf_border)
    draw_clear_alpha(0,0)
    
    if is_struct(global.border_struct)
        global.border_struct._drawer(960, 540, 1)
    
    gpu_set_blendmode(bm_subtract)
    draw_rectangle(960/2 - 320, 540/2 - 240, 960/2 + 320 - 1, 540/2 + 240 - 1, false) // the cut-out
    gpu_set_blendmode(bm_normal)
    surface_reset_target()
    
    if surface_exists(surf_prev) && global.border_trans < 1
        draw_surface_ext(surf_prev, 320 - 960/2, 240 - 540/2, 1, 1, 0, c_white, 1 - global.border_trans)
    draw_surface_ext(surf_border, 320 - 960/2, 240 - 540/2, 1, 1, 0, c_white, global.border_trans)
}