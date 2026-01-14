function ex_enc_set_shadowguys() : enc_set() constructor {
	debug_name	=	"shadowguys"
    
	enemies = [
		new ex_enemy_shadowguy(),
		new ex_enemy_shadowguy(),
	]
	flavor = "* Shadowguys Strike!"
    
	enemies_pos = [
		[-4, -6, true],
		[-14, 6, true]
	]
}

// revive action used for the example below
//function ex_item_s_revivekris(nname) : item_s_defaultaction(nname) constructor {
    //name = loc("ex_spell_revivekris")
	//desc = ["", loc("ex_spell_revivekris_desc")]
    //use_type = ITEM_USE.EVERYONE
    //
    //is_party_act = false
    //use = function() {}
	//tp_cost = 16
//}
function ex_enc_set_spawn() : enc_set() constructor {
	debug_name	=	"spawnlings"
    
	enemies = [
		new ex_enemy_spawnling(),
		new ex_enemy_dentos(),
	]
	flavor = "* Darkness constricts you...{br}{resetx}* {col(y)}TP{col(w)} Gain reduced outside of {col(g)}COURAGE{col(w)}!"
    bgm = mus_ex_spawn
    
    // positions
    enemies_pos = function(i, xx, yy) {
        return [
            xx - i*10,
            yy
        ]
    }
    
    // array_push(party_actions.ralsei, new ex_item_s_revivekris("ralsei")) // this is how you'd add a bonus act like revivekris
    // array_delete(party_actions.ralsei, 0, 1) // you can also just straight up delete the r-action if you want to 
    
    enc_var_struct = {
        tp_constrict: true,
    }
}