function ex_enc_set_shadowguys() : enc_set() constructor {
	debug_name	=	"shadowguys"
	enemies = [
		new ex_enemy_shadowguy(),
		new ex_enemy_shadowguy(),
	]
	enemies_pos=[
		[-4, -6, true],
		[-14, 6, true]
	]
	flavor = "* undefined"
}