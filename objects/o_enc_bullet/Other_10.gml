if o_enc_soul.i_frames > 0 
	exit

if color == 1
	if !o_enc_soul.moving 
		exit
else if color == 2
	if o_enc_soul.moving 
		exit

o_enc_soul.i_frames = inv
o_enc_soul.image_index = 1

party_attack_targets(att, o_enc, element)

if color == 0 && destroy
	instance_destroy()