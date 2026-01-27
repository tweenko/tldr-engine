function ch5_enc_set_knight() : enc_set() constructor {
    debug_name	=	"example"
    bgm = mus_shrieking_soil
    
	enemies = [
		new ch5_enemy_knight()
	]
    
    party_pos = function(i) { // returns [x, y]
        return [
            guipos_x() + 82 - i*16,
            guipos_y() + 120 - 16 * array_length(global.party_names) + i*32,
        ]
    }
    enemies_pos = [
        [-10, 0, true]
    ]
    
    bg_type = ENC_BG.NONE
    flavor = "* An unexpected alliance forms."
    
    ev_init = function() {
        instance_create(o_ch5_eff_shriekbg)
        instance_create(o_ch5_eff_e_knight_trail)
    }
}