function gb_enc_set() : enc_set() constructor {
	debug_name	=	"malign_combat"
    
	enemies = [
		new ex_enemy_custodian(),
		new ex_enemy_lodestar(),
	]
	flavor = "* Cold entropy constricts you...{br}{resetx}* {col(y)}TP{col(w)} Gain reduced outside of {col(g)}COURAGE{col(w)}!"
    
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