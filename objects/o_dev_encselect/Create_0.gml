selection = 0;
global.console = true
depth = DEPTH_UI.CONSOLE

encounters = [
	new enc_set_ex(),
	new enc_set_virovirokun(),
	new ex_enc_set_shadowguys(),
    new ex_enc_set_spawn(),
]

enc_names = []

for (var i = 0; i < array_length(encounters); i++){
	var enc_name = encounters[i].debug_name
	enc_names[i] = enc_name
}