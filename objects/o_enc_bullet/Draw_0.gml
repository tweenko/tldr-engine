if inside { // draws on the box surface
	surface_set_target(o_enc_box.bullet_surf)
	event_user(1)
	surface_reset_target()
}
else
	event_user(1)