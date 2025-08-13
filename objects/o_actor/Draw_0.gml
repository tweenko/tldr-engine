var spr = sprite_index

// set the hurt sprite if hurt
if is_player || is_follower
	s_hurt = party_getdata(name, "battle_sprites").hurt
if hurt > 0 && is_in_battle || run_away && is_in_battle && is_enemy
	spr = s_hurt
	
if (is_player || is_follower) && party_getdata(name, "is_down") 
	spr = party_getdata(name, "battle_sprites").defeat

var xx = x + xoff + sine(1, xshake)
var yy = y + yoff

var isave = image_blend
image_blend = merge_color(c_white, c_black, darken)

if dodge_lerper > 0 && is_player { // outline and bg darkener
	if !surface_exists(dodge_outline_surf) // create outline surface
		dodge_outline_surf = surface_create(320, 240)
	
	surface_set_target(dodge_outline_surf){ // draw red outline
		draw_clear_alpha(0, 0)
		gpu_set_fog(true, c_red, 0, 0)
	
		for (var i = 0; i < 360; i += 90) {
			var xdelta = lengthdir_x(1, i)
			var ydelta = lengthdir_y(1, i)
			
		    s_drawer(spr, image_index, 
				160 + xdelta, 120 + ydelta,
				image_xscale, image_yscale,
				image_angle,image_blend,image_alpha
			)
		}
		
		gpu_set_fog(false,c_white,0,0)
	}
	surface_reset_target()
	
	draw_surface_ext(dodge_outline_surf, xx - 160, yy - 120, 1, 1, 0, c_white, dodge_lerper)
}

// draw the sprite
s_drawer(spr, image_index, 
	xx, yy, 
	image_xscale, image_yscale, 
	image_angle, image_blend, image_alpha
)

if freeze > 0 {
    var __freezecol = merge_color(c_navy, c_white, 0.8)
    var t = (sprite_height) - (freeze * (sprite_height));
    
    gpu_set_fog(true, __freezecol, 0, 0);
    
    var yoffset = -(sprite_get_yoffset(sprite_index) * image_yscale);
    var xoffset = -(sprite_get_xoffset(sprite_index) * image_xscale);
    
    draw_sprite_part_ext(sprite_index, image_index, 0, t, sprite_width, sprite_height - t, (x - 1) + xoffset, (y - 1) + t + yoffset, image_xscale, image_yscale, c_blue, image_alpha * 0.8);
    draw_sprite_part_ext(sprite_index, image_index, 0, t, sprite_width, sprite_height - t, x + 1 + xoffset, (y - 1) + t + yoffset, image_xscale, image_yscale, c_blue, image_alpha * 0.4);
    draw_sprite_part_ext(sprite_index, image_index, 0, t, sprite_width, sprite_height - t, (x - 1) + xoffset, y + 1 + t + yoffset, image_xscale, image_yscale, c_blue, image_alpha * 0.4);
    draw_sprite_part_ext(sprite_index, image_index, 0, t, sprite_width, sprite_height - t, x + 1 + xoffset, y + 1 + t + yoffset, image_xscale, image_yscale, c_blue, image_alpha * 0.8);
    gpu_set_fog(false, c_white, 0, 0);
    
    gpu_set_blendmode(bm_add);
    draw_sprite_part_ext(sprite_index, image_index, 0, t, sprite_width, sprite_height - t, x + xoffset, y + t + yoffset, image_xscale, image_yscale, __freezecol, image_alpha * 0.4);
    gpu_set_blendmode(bm_normal);
}

if !surface_exists(s_lightsurf)
	s_lightsurf = surface_create(320, 240)

// the light on the top of the character's sprite
if s_lightalpha > 0 {
	surface_set_target(s_lightsurf) {
		draw_clear_alpha(0, 0)
	
		gpu_set_fog(true, lighting_color, 0, 1)
		s_drawer(spr, image_index, 
			sprite_xoffset, sprite_yoffset, 
			image_xscale, image_yscale, 
			image_angle, c_white, 1
		)
		gpu_set_fog(false, 0, 0, 0)
	
		gpu_set_blendmode(bm_subtract)
		s_drawer(spr, image_index, 
			sprite_xoffset, sprite_yoffset + 1, 
			image_xscale, image_yscale, 
			image_angle, c_black, 1
		)
		gpu_set_blendmode(bm_normal)
	}
	surface_reset_target()
	
	// the shadow on the actor
	s_drawer(spr, image_index, 
		xx, yy, 
		image_xscale, image_yscale, 
		image_angle, c_black, s_lightalpha * lighting_darken
	)
	draw_surface_ext(s_lightsurf, xx - sprite_xoffset, yy - sprite_yoffset, 1, 1, 0, c_white, s_lightalpha)

	// the shadow on the ground
	s_drawer(spr, image_index, 
		xx, yy, 
		image_xscale, lerp_type(0, -2, s_lightalpha, "cubic_out"), 
		image_angle, c_black, image_alpha
	)
}

// draw the sweat sprite
if sweat {
	draw_sprite_ext(spr_eff_enemysweat, image_index, 
		x-sprite_get_xoffset(spr)*image_xscale,
		y-sprite_get_yoffset(spr)*image_yscale, 
		.5, .5, 
		image_angle, image_blend, image_alpha
	)
}
	
// dim the leader while dodging
if dodge_lerper > 0 && is_player{ 
	gpu_set_fog(true, merge_color(c_black, c_dkgray, .5), 0, 0)
	s_drawer(spr, image_index, xx, yy, image_xscale, image_yscale, image_angle, image_blend, .8 * dodge_lerper)
	gpu_set_fog(false,c_white,0,0)
}

if flashing { // battle select flash
	gpu_set_fog(true, c_white, 0, 0)
	s_drawer(spr, image_index, xx, yy, image_xscale, image_yscale, image_angle, c_white, (((-(cos((fsiner / 5)))) * 0.4) + 0.6))
	gpu_set_fog(false,c_white,0,0)
}
if flash > 0 { // normal flash
	gpu_set_fog(true, flash_color, 0, 0)
	s_drawer(spr, image_index, xx, yy, image_xscale, image_yscale, image_angle, c_white, flash)
	gpu_set_fog(false, flash_color, 0, 0)
}

if instance_exists(get_leader()) && !is_player{
	if get_leader().dodge_lerper > 0{
		s_drawer(spr, image_index, xx, yy, image_xscale, image_yscale, image_angle, c_black, get_leader().dodge_lerper * .5)
	}
}

image_blend = isave