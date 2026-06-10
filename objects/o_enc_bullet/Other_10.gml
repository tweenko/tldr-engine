if o_enc_soul.i_frames > 0 
	exit

if color == BULLET_COLOR.BLUE
	if !o_enc_soul.moving 
		exit
else if color == BULLET_COLOR.ORANGE
	if o_enc_soul.moving 
		exit

o_enc_soul.i_frames = inv
o_enc_soul.image_index = 1

party_attack_targets(att, o_enc, element)

if color == BULLET_COLOR.SOLID && destroy
	instance_destroy()