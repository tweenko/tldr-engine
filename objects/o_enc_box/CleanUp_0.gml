if surface_exists(bullet_surf) 
	surface_free(bullet_surf)
if surface_exists(trans_surf) 
	surface_free(trans_surf)

instance_destroy(solid_left)
instance_destroy(solid_right)
instance_destroy(solid_top)
instance_destroy(solid_bottom)

sprite_flush(trans_sprite)