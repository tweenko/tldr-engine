/// @desc
if grazed_inst.color != 0{
	exit
}

o_enc.tp += grazed_inst.graze
o_enc.tp = clamp(o_enc.tp,0,100)

audio_play(snd_graze)

image_index=0;
image_alpha=1