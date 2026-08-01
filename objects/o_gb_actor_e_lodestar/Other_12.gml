/// @description auto sprite load
if s_auto && name != "" {
    if is_party {
        var party_struct = party_get_struct(name)
        
    	var cardinal = method_call(party_struct.__get_cardinal, [name]);
        var cardinal_struct_names = struct_get_names(cardinal);
        for (var i = 0; i < array_length(cardinal_struct_names); i ++) {
            variable_instance_set(id, cardinal_struct_names[i], struct_get(cardinal, cardinal_struct_names[i]));
        }
        
        s_ball = method_call(party_struct.__get_sprite, [name, "ball"])
        s_landed = method_call(party_struct.__get_sprite, [name, "landed"])
        s_slide = method_call(party_struct.__get_sprite, [name, "slide"])
        lb_dl_highlight_color = merge_colour(party_getdata(name, "iconcolor"), c_white, .4)
    }
}