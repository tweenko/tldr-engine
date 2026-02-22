function enc_set() constructor { // base
	debug_name	=	"undefined"
    
	enemies	= []
    bgm = mus_battle
	bg_type = ENC_BG.GRID
    
    flavor = function() { // can also be a string
		var text = "* undefined"
		return text
	}
    win_condition = function() {}
    
    // positions
	enemies_pos = undefined // [x, y, relative] OR just a function that returns [x, y]
    party_pos = function(i) { // returns [x, y]
        return [
            guipos_x() + 52,
            guipos_y() + 130 - 22 * array_length(global.party_names) + i*44,
        ]
    }
	
    // actions  
    party_actions = {}
    // add the default party actions. if you want to remove them from an encounter, just set party_actions back to an empty struct
	for (var i = 0; i < array_length(global.party_names); ++i) {
	    struct_set(party_actions, global.party_names[i], [new item_s_defaultaction(global.party_names[i])])
	}
    
    // miscellaneous config
    can_change_turnlen = true // by defending
	display_target = false // whether to display the targets of the enemy's attack, like in chapter 1
    enc_var_struct = {}
	
    // in-fight-events
    ev_init =           -1 // called 1 frame after o_enc is created
    ev_party_turn =     -1
    ev_pre_dialogue =   -1
	ev_dialogue =	    -1
	ev_turn =	  	    -1
    ev_turn_start =     -1
	ev_post_turn =	    -1
    ev_win =            -1
    
	// methods
    _target_calculation = function() { // should return an array of indexes of party members who are targeted
        var __targets = []
        for (var i = 0; i < array_length(global.party_names); ++i) {
		    if party_getdata(global.party_names[i], "hp") > 0
				array_push(__targets, global.party_names[i])
		}
        
        return __targets
    }
    _target_recalculate_condition = function(__current_targets) {
        return false
    }
    
	_start = function() {
		enc_start(self)
	}
}

function enc_set_ex() : enc_set() constructor {
	debug_name	=	"example"
    
	enemies = [
		new enemy_virovirokun(),
		new enemy_killercar(),
		new enemy_virovirokun(),
	]
    enemies[0].defeat_marker = 0
    enemies[2].defeat_marker = 1
    flavor = "* The test crew is approaching!!"
    
	enemies_pos = [
		[0, 0, true],
		[-20, 0, true]
	]
    
    _target_calculation = function() {
        var __targets = []
        for (var i = 0; i < array_length(global.party_names); ++i) {
		    if party_getdata(global.party_names[i], "hp") > 0
				array_push(__targets, global.party_names[i])
		}
        
        if array_length(__targets) == 0
            return -1
        return [array_shuffle(__targets)[0]]
    }
    _target_recalculate_condition = function(__current_targets) {
        return (!party_isup(__current_targets[0]) ? true : false)
    }
}
function enc_set_virovirokun() : enc_set() constructor {
	debug_name	=	"virovirokun"
	enemies = [
		new enemy_virovirokun(),
		new enemy_virovirokun(),
	]
	enemies_pos = [
		[0, 0, true],
		[-20, 0, true]
	]
	flavor = "* Virovirokun floated in!"
}