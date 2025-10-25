function enc_set() constructor { // base
	debug_name	=	"undefined"
	enemies	= []
    
	enemies_pos = undefined // x, y, relative (bool) -- if not relative, guipos is added OR just a function
    party_pos = function(i) { // returns [x, y]
        return [
            guipos_x() + 52,
            guipos_y() + 130 - 22*array_length(global.party_names) + i*44,
        ]
    }
    
	flavor = function() { // can also be a string
		var text = "* undefined"
		return text
	}
	bgm = mus_battle
	bg_type = ENC_BG.GRID
    
    can_change_turnlen = true
    enc_var_struct = {}	
    
	display_target = true // whether to display the targets of the enemy's attack
	
	// methods
    _target_calculation = function() { // should return an array of indexes of party members who are targeted
        var __targets = []
        
        for (var i = 0; i < array_length(global.party_names); ++i) {
		    if party_getdata(global.party_names[i], "hp") > 0
				array_push(__targets, global.party_names[i])
		}
        
        return __targets
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
    
	enemies_pos = [
		[0, 0, true],
		[-20, 0, true]
	]
	
	flavor = "* The test crew is approaching!!"
    
    _target_calculation = function() {
        var __targets = []
        
        for (var i = 0; i < array_length(global.party_names); ++i) {
		    if party_getdata(global.party_names[i], "hp") > 0
				array_push(__targets, global.party_names[i])
		}
        
        return [array_shuffle(__targets)[0]]
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