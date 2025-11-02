dodge_mode = false
dodge_override = false // do this if you want to control the lighting amount manually

dodge_darken = .5
dodge_alpha = 0

target_layers = []

depth = 0

__find_target_layers = function() {
    target_layers = []
    
    // add the room layers that fit the criteria
    
    var __all_layers = layer_get_all()
    for (var i = 0; i < array_length(__all_layers); i ++) {
        if string_contains("dodge_overlay", layer_get_name(__all_layers[i])) 
            array_push(target_layers, __all_layers[i])
    }
    
    for (var i = 0; i < array_length(target_layers); i ++) {
        layer_set_visible(target_layers[i], true)
    	
        var lay_id = target_layers[i]
    	layer_script_begin(lay_id, function() {
    		shader_set(shd_transparent)
    		shader_set_uniform_f(shader_get_uniform(shd_transparent, "alpha"), o_dodge_controller.dodge_alpha)
    	})
    	
    	layer_script_end(lay_id, function() {
    		if shader_current() != -1 {
    			shader_reset()
    		}
    	})
    }
}

__find_target_layers()