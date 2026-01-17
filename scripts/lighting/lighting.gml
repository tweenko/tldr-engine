/// @desc turns on the lighting effect with a certain color
/// @arg {Constant.Colour} color the color the highlight on the characters will be
/// @arg {Constant.Colour} fade_color the color of the fade that will be applied
function lighting_on(color, fade_color = c_gray) {
    if !instance_exists(o_eff_lighting_controller)
        return false
    
    o_eff_lighting_controller.color = color 
    o_eff_lighting_controller.fade_color = fade_color
    o_eff_lighting_controller.under_lighting = true
}

/// @desc turns off the lighting effect
function lighting_off() {
    if !instance_exists(o_eff_lighting_controller)
        return false
    
    o_eff_lighting_controller.under_lighting = false
}

/// @desc draw_self but it darkens depending on the lighting the player is recieving
/// @arg {function|undefined} drawer the function that draws your object
function lighting_darken_self(drawer = undefined) {
    if !instance_exists(o_eff_lighting_controller)
        return false
    
    var __emitting_light = false
    if variable_instance_exists(self, "am_emitting_light")
        __emitting_light = am_emitting_light
    
	if o_eff_lighting_controller.lighting_alpha > 0 && !__emitting_light {
        if !is_undefined(drawer) && is_callable(drawer)
            drawer(sprite_index, image_index,
    			x, y, image_xscale, image_yscale,
    			image_angle, c_black, o_eff_lighting_controller.lighting_alpha * o_eff_lighting_controller.lighting_darken
    		)
        else
     		draw_sprite_ext(sprite_index, image_index,
     			x, y, image_xscale, image_yscale,
     			image_angle, c_black, o_eff_lighting_controller.lighting_alpha * o_eff_lighting_controller.lighting_darken
     		)
	}
}