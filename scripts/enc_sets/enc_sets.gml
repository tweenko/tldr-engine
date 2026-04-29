function enc_set() constructor { // base
	debug_name	=	"undefined"
    
	enemies	= []
	bg_type = ENC_BG.GRID
    
    flavor = function() { // can also be a string
		var text = "* undefined"
		return text
	}
    win_condition = function() { // if this is true, the battle will end
        for (var i = 0; i < array_length(o_enc.encounter_data.enemies); ++i) {
            if enc_enemy_isfighting(i)
                return false;
        }
        return true;
    }
    
    bgm = mus_battle
    bgm_pitch = 1
    bgm_gain = 1
    
    // positions
	enemies_pos = undefined // [x, y, relative] OR just a function that returns [x, y]
    party_pos = function(i) { // returns [x, y]
        return [
            guipos_x() + 52,
            guipos_y() + 130 - 22 * party_length() + i*44,
        ]
    }
	
    // actions  
    party_actions = {}
    // add the default party actions. if you want to remove them from an encounter, just set party_actions back to an empty struct
	for (var i = 0; i < party_length(); ++i) {
	    struct_set(party_actions, global.party_names[i], [new item_s_defaultaction(global.party_names[i])])
	}
    
    // miscellaneous config
    can_change_turnlen = true // by defending
	display_target = false // whether to display the targets of the enemy's attack, like in chapter 1
    enc_var_struct = {}
	
    // in-fight-events
    ev_init =           -1 // called 1 frame after o_enc is created
    ev_party_turn =     -1
    ev_party_exec =     -1
    ev_pre_dialogue =   -1
	ev_dialogue =	    -1
	ev_turn =	  	    -1
    ev_turn_start =     -1
	ev_post_turn =	    -1
    ev_win =            -1
    
	// methods
    target_calculation = ENC_TARGET.RANDOM // if callable, should return an array of indexes of party members who are targeted
    target_recalculate_condition = undefined
    
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
    
    target_calculation = ENC_TARGET.ANY
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
    
    target_calculation = ENC_TARGET.ALL
}