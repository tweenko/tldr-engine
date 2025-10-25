selection = 0;
global.console = true
depth = DEPTH_UI.CONSOLE

encounters = [
	enc_set_ex,
	enc_set_virovirokun,
	ex_enc_set_shadowguys,
    ex_enc_set_spawn,
]

enc_names = []

for (var i = 0; i < array_length(encounters); i++){
	var enc_name = script_get_name(encounters[i])
	enc_names[i] = enc_name
}