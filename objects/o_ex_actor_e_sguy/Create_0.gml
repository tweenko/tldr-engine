event_inherited()
s_hurt = spr_ex_e_sguy_idle
s_spared = spr_e_virovirokun_hurt

gun = 0
gun_angle = 0
gun_img = 0

moveseed = [0, 0]
my_socks = noone

hits = 0

s_drawer = function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
	if gun {
		if gun_img > 2 
			gun_img = 0
		_sprite = spr_ex_e_sguy_shoot
		
		draw_sprite_ext(spr_ex_e_sguy_gun, gun_img,
			_xx - sprite_get_xoffset(_sprite) + 4, _yy - sprite_get_yoffset(_sprite) + 34,
			image_xscale, image_yscale, gun_angle, image_blend, image_alpha
		)
	}
	
	draw_sprite_ext(_sprite, _index, 
		_xx, _yy, 
		_xscale, _yscale, 
		_angle, _blend, _alpha
	)
}