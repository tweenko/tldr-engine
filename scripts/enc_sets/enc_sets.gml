function enc_set() constructor { // base
	debug_name	=	"undefined"
	enemies	= [
	]
	enemies_pos = [ // x, y, relative (bool) -- if not relative, guipos is added
	]
	flavor = "* undefined"
	bgm = mus_battle
	bg_type = 0 // default, no bg
	
	display_target = true // whether to display the target of the enemy's attack
	
	//methods
	start = function() {
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
	bgm = -1
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
	bgm = -1
}