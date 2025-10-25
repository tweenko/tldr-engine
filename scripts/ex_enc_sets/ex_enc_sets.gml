function ex_enc_set_shadowguys() : enc_set() constructor {
	debug_name	=	"shadowguys"
	enemies = [
		new ex_enemy_shadowguy(),
		new ex_enemy_shadowguy(),
	]
	enemies_pos = [
		[-4, -6, true],
		[-14, 6, true]
	]
	flavor = "* undefined"
}

function ex_item_s_revivekris(nname) : item_s_defaultaction(nname) constructor {
    name = loc("ex_spell_revivekris")
	desc = ["", loc("ex_spell_revivekris_desc")]
    use_type = ITEM_USE.EVERYONE
    
    is_party_act = false
    use = function() {

    }
	tp_cost = 16
}
function ex_enc_set_spawn() : enc_set() constructor {
	debug_name	=	"spawnlings"
	enemies = [
		new ex_enemy_spawnling(),
		new ex_enemy_dentos(),
	]
    enemies_pos = function(i, xx, yy) {
        return [
            xx - i*10,
            yy
        ]
    }
    
    bgm = mus_ex_spawn
    
	flavor = "* Darkness constricts you...{br}{resetx}* {col(y)}TP{col(w)} Gain reduced outside of {col(g)}COURAGE{col(w)}!"
    enc_var_struct = {
        tp_constrict: true,
        // bonus_actions: { -- this is an example of how you'd do the revive action
            // susie: [new ex_item_s_revivekris("susie")],
            // ralsei: [new ex_item_s_revivekris("ralsei")]
        // },
    }
}