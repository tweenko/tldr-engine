/// @description auto sprite load
if is_follower || is_player 
	s_state = party_getdata(name, "s_state")

if s_auto && name != "" {
    var sp = s_prefix
    if sp != ""
    	sp += "_"
    
    var fstate = s_state
    fstate += (global.world == WORLD_TYPE.LIGHT ? "_light" : "")
    
	var __conv_sprite_pm = function(_identifier, _prefix, _fstate, _default = s_move[DIR.DOWN]){
		var __a = asset_get_index_state($"spr_{_prefix}{name}_{_identifier}", _fstate)
		if sprite_exists(__a) 
			return __a
		else 
			return _default
	}
	
    s_move[DIR.UP] = __conv_sprite_pm("up", sp, fstate)
    s_move[DIR.RIGHT] = __conv_sprite_pm("right", sp, fstate)
    s_move[DIR.DOWN] = __conv_sprite_pm("down", sp, fstate)
    s_move[DIR.LEFT] = __conv_sprite_pm("left", sp, fstate)
    
    s_ball = __conv_sprite_pm("ball", sp, fstate)
    s_landed = __conv_sprite_pm("landed", sp, fstate)
    s_slide = __conv_sprite_pm("slide", sp, fstate)
}