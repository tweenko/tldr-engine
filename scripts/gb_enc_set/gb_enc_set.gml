function gb_enc_set_malign() : enc_set() constructor {
	debug_name	=	"gb_enc_malign_combat"
    
	enemies = [
		new gb_enemy_custodian(),
		new gb_enemy_lodestar(),
	]
	 flavor = function() {
        if o_enc.turn_count == 0 
            return "* Cold entropy constricts you...{br}{resetx}* {col(y)}TP{col(w)} Gain reduced outside of {col(g)}COURAGE{col(w)}!"
		if party_getdata(kris, "hp") < 1
			return "{char(ralsei, 52)} * We're too close to the monument! We can't lose this now!"
        return choose(
			"* Wisps of energy fly around you."	,
			"* Why did you choose to be this way?",
			"* The constructs stare at you coldly.",
			"* Your soul's light struggles to fight the malign influence.",
		)
	 }

    bgm = mus_blood
    bgm_pitch = 1
    bgm_gain = 1
    
    // positions
    enemies_pos = function(i, xx, yy) {
        return [
            xx,
            yy
        ]
    }
    
    target_calculation = ENC_TARGET.ANY
    enc_var_struct = {
        tp_constrict: true,
    }
}