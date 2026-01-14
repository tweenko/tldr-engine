var full = false

if !surface_exists(tp_surf)
    tp_surf = surface_create(640, 480)
if !surface_exists(surf)
    surf = surface_create(640, 480)

surface_set_target(surf)
    draw_clear_alpha(0,0)
    surface_set_target(tp_surf) {
        draw_clear_alpha(0, 0)
        draw_set_font(loc_font("main"))
        draw_set_color(c_white)
        
        draw_sprite_ext(spr_ui_enc_tpbar_caption, 0, x - 40 + x_offset, y - 61, 2, 2, 0, c_white, 1)
        
        if ceil(tp_visual) >= 100 {
            full = true
            
            draw_set_color(c_yellow)
            draw_text_transformed(x-40 + x_offset, y-20, "M", 2, 2, 0)
            draw_text_transformed(x-36 + x_offset, y, "A", 2, 2, 0)
            draw_text_transformed(x-32 + x_offset, y+20, "X", 2, 2, 0)
        }
        else {
            draw_text_transformed(x-42 + x_offset, y-28, round(tp_visual_fast), 2, 2, 0)
            draw_text_transformed(x-37 + x_offset, y-3, "%", 2, 2, 0)
        }
    }
    surface_reset_target()
    
    draw_surface(tp_surf, 0, 0)
    draw_set_alpha(tp_glow_alpha)
    
    gpu_set_blendmode(bm_add)
    for (var i = 0; i < 360; i += 45) {
        draw_surface(tp_surf, lengthdir_x(2, i), lengthdir_y(2, i))
    }
    gpu_set_blendmode(bm_normal)
    
    draw_set_alpha(1)
    
    var __c_unfilled = c_red
    var __c_filled = (!full ? c_orange : c_yellow)
    var __c_outline = c_white
    if caller.tp_constrict {
        __c_unfilled = c_blue
        
        __c_filled = merge_color(c_blue, c_teal, 0.5)
        if full
            __c_filled = merge_color(c_teal, __c_filled, 0.5)
    }
    
    draw_sprite_ext(spr_ui_enc_tpbar, (caller.tp_constrict ? 2 : 1), x + x_offset, y, 1, 1, 0, c_white, 1)
    
    var __tp_fill = (100 - tp_visual) / 100
    var __tp_fill_fast = (100 - tp_visual_fast) / 100
    var __tp_x_origin = x + x_offset - 9
    
    if tp_visual_fast < tp_visual {
        draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
            0, __tp_fill * 187, 
            18, tp_visual/100 * 187,
            __tp_x_origin, y-92 + __tp_fill * 187,
            1, 1, __c_unfilled, 1
        )
        draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
            0, __tp_fill_fast * 187,
            18, tp_visual_fast/100 * 187, 
            __tp_x_origin, y-92 + __tp_fill_fast * 187,
            1, 1, __c_filled, 1)
        
        if !full {
            draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
                0, __tp_fill * 187,
                18, 2,
                __tp_x_origin, y-92 + __tp_fill * 187,
                1, 1, __c_outline, 1
            )
        }
    }
    else {
        draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
            0, __tp_fill_fast * 187,
            18, tp_visual_fast/100 * 187, 
            __tp_x_origin, y-92 + __tp_fill_fast * 187,
            1, 1, __c_outline, 1
        )
        draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
            0, __tp_fill * 187, 
            18, tp_visual/100 * 187,
            __tp_x_origin, y-92 + __tp_fill * 187,
            1, 1, __c_filled ,1
        )
        
        if !full {
            draw_sprite_part_ext(spr_ui_enc_tpfilling, 0,
                0, __tp_fill_fast * 187,
                18, 2, 
                __tp_x_origin, y-92 + __tp_fill_fast * 187,
                1, 1, __c_outline, 1
            )
        }
    }
    
    // cost indicator
    if tp_cost_display != 0
       draw_sprite_part_ext(spr_ui_enc_tpfilling, 0, 
           0, __tp_fill_fast * 187,
           18, tp_cost_display/100 * 187, 
           __tp_x_origin, y-92 + __tp_fill * 187,
           1, 1, c_white, sine(6, .3) + .6
       )
    
    draw_sprite_ext(spr_ui_enc_tpfilling, 0, x + x_offset, y - 92, 1, 1, 0, c_white, tp_glow_alpha)
surface_reset_target()

draw_surface(surf, 0, 0)