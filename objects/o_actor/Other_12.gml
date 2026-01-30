/// @description auto sprite load
if s_auto && name != "" {
    if is_party {
        var party_struct = party_get_struct(name)
    	s_move = method_call(party_struct.__get_cardinal, [name])
        
        s_ball = method_call(party_struct.__get_sprite, [name, "ball"])
        s_landed = method_call(party_struct.__get_sprite, [name, "landed"])
        s_slide = method_call(party_struct.__get_sprite, [name, "slide"])
        
        lb_dl_highlight_color = merge_colour(party_getdata(name, "iconcolor"), c_white, .4)
    }
}