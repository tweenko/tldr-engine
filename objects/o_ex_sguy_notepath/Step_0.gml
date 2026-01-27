if timer > 15 && buffer == 0 && count < 10 {
	var inst = instance_create(o_ex_bullet_sguy_note, shadx, shady, depth)
	
    var p = path
	with inst
		path_start(p, 10, path_action_stop, 1)
    
	buffer = 3
	count ++
}

if buffer > 0 
    buffer--
timer++

if image_alpha == 0 
    instance_destroy()