global.can_use_borders = true // whether the player can use borders
global.border = false

global.current_dynamic_border = border_none
global.border_struct = new border_none()

enum BORDER_MODE {
    DYNAMIC = 0,
    SIMPLE = 1,
    NONE = 2,
    OFF = 3
}
global.border_mode_count = 4

global.border_trans = 1
global.border_trans_anim = undefined

/// @desc the base constructor for all borders
function border() constructor {
    _name = "Undefined"
    
    _sprite = spr_border_simple
    
    _step = undefined
    _drawer = method(self, function(_width, _height, _alpha) {
        draw_sprite_stretched_ext(_sprite, 0, 0, 0, _width, _height, c_white, _alpha)
    })
}

function border_none() : border() constructor {
    _name = "None"
    _drawer = function() {}
}

function border_simple() : border() constructor {
    _name = "Simple"
    _sprite = spr_border_simple
}

/// @desc toggles the borders
/// @arg {bool} [borders_on] whether to turn on or turn off the borders
function borders_toggle(borders_on = !global.border) {
    var need_to_adjust = (global.border != borders_on)
    
    global.border = borders_on
    if global.border_mode == BORDER_MODE.OFF && borders_on
        global.border_mode = BORDER_MODE.DYNAMIC
    
    if need_to_adjust
        borders_window_resize(global.border)
}

/// @arg {function} border  the border struct of the target border
/// @arg {bool} force       whether to set the border even if they aren't dynamic
function border_set(_border, _force = false) {
    if instanceof(_border) == instanceof(global.border_struct) // don't do anything if the previous border and the current border are the same
        return
    if !global.border
        return
    
    with o_window {
        if !surface_exists(surf_border)
            break
        if !surface_exists(surf_prev)
            surf_prev = surface_create(surface_get_width(surf_border), surface_get_height(surf_border))
        
        surface_set_target(surf_prev)
        draw_clear_alpha(0,0)
        surface_reset_target()
        
        surface_copy(surf_prev, 0, 0, surf_border)
        
        surface_set_target(surf_prev)
        gpu_set_blendmode(bm_subtract)
        draw_rectangle(960/2 - 320, 540/2 - 240, 960/2 + 320 - 1, 540/2 + 240 - 1, false) // the cut-out
        gpu_set_blendmode(bm_normal)
        surface_reset_target()
    }
    
    global.border_struct = new _border() // update the border struct
    
    anime_stop(global.border_trans_anim)
    global.border_trans_anim = anime_tween(0, 1, 30, anime_curve.linear, function(v) {
        global.border_trans = v
    })._start()
}

/// @desc resizes the window upon toggling borders. usage is fully internal
function borders_window_resize(borders_on = global.border, window_size = o_world.window_scale) {
    var res_borders = [960 * window_size, 540 * window_size]
    var res_window = [640 * window_size, 480 * window_size]
    
    var winx = window_get_x()
    var winy = window_get_y()
    if borders_on {
        window_set_size(res_borders[0], res_borders[1])
        winx -= (res_borders[0] - res_window[0])/2
        winy -= (res_borders[1] - res_window[1])/2
    }
    else {
        window_set_size(res_window[0], res_window[1])
        winx -= (res_window[0] - res_borders[0])/2
        winy -= (res_window[1] - res_borders[1])/2
    }
    
    window_set_position(winx, winy)
}