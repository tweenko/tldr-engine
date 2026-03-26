function ex_enc_set_shadowguys() : enc_set() constructor {
	debug_name	=	"shadowguys"
    
	enemies = [
		new ex_enemy_shadowguy(),
		new ex_enemy_shadowguy(),
	]
    
	flavor = function() {
        if o_enc.turn_count == 0 
            return "* Shadowguys play on in."
        return choose(
            "* Shadowguy plays the blues, blues, blues.",
            "* Shadowguy snaps their fingers rhythmically.",
            "* Shadowguy rolls up their socks... secretly.",
            "* Shadowguy's got the moves and the groove."
        )
    }
    
	enemies_pos = [
		[-4, -6, true],
		[-14, 6, true]
	]
}

function ex_enc_set_spawn() : enc_set() constructor {
	debug_name	=	"spawnlings"
    
	enemies = [
		new ex_enemy_spawnling(),
		new ex_enemy_dentos(),
	]
	flavor = "* Darkness constricts you...{br}{resetx}* {col(y)}TP{col(w)} Gain reduced outside of {col(g)}COURAGE{col(w)}!"
    
    bgm = mus_ex_spawn
    bgm_pitch = 1
    bgm_gain = 1
    
    // positions
    enemies_pos = function(i, xx, yy) {
        return [
            xx - i*10,
            yy
        ]
    }
    
    target_calculation = ENC_TARGET.ANY
    enc_var_struct = {
        tp_constrict: true,
    }
}