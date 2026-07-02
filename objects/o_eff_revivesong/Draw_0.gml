if !instance_exists(target_actor)
    exit;

x = target_actor.x;
y = target_actor.y;

if target_actor.name == "susie"
    x += 1;
if target_actor.name == "ralsei"
    x += 6;

var beam_w = 63 * beam_rad;
var beam_h = 15 * beam_rad;

if !surface_exists(surf_light)
    surf_light = surface_create(640, 480);
if !surface_exists(surf_feathers)
    surf_feathers = surface_create(640, 480);

surface_set_target(surf_light);
    draw_clear_alpha(0, 0);
    draw_cone(x*2, y*2 - 360, x*2, y * 2, beam_w,,, .85);
    draw_ellipse(x*2 - beam_w, y*2 - beam_h, x*2 + beam_w, y*2 + beam_h, false);
surface_reset_target();

surface_set_target(surf_feathers);
    draw_clear_alpha(0, 0);
    
    with o_eff_revivesong_feather
        draw_sprite_ext(sprite_index, image_index, x*2 - guipos_x(), y*2 - guipos_y(), image_xscale*2, image_yscale*2, image_angle, image_blend, image_alpha);
    
    gpu_set_colourwriteenable(true, true, true, false);
    draw_surface_ext(surf_light, 0, 0, 1, 1, 0, #FFB56C, image_alpha * .5); // make feathers react to lighting
    gpu_set_colourwriteenable(true, true, true, true);
surface_reset_target();

draw_surface_ext(surf_light, guipos_x(), guipos_y(), .5, .5, 0, #FFB56C, image_alpha * .8);

with target_actor {
    var xx = x + xoff + sine(.5, shake);
    var yy = y + yoff;
    
    gpu_set_fog(true, #FFB56C, 0, 1);
    s_drawer(sprite_index, image_index, xx, yy - 1, image_xscale, image_yscale, image_angle, image_blend, image_alpha * other.image_alpha);
    gpu_set_fog(false, c_white, 0, 0);
    
    s_drawer(sprite_index, image_index, xx, yy, image_xscale, image_yscale, image_angle, #807976, image_alpha * other.image_alpha);
    
	gpu_set_fog(true, flash_color, 0, 0)
	s_drawer(sprite_index, image_index, xx, yy, image_xscale, image_yscale, image_angle, c_white, flash * alpha_mod);
	gpu_set_fog(false, flash_color, 0, 0)
}

draw_surface_ext(surf_feathers, guipos_x(), guipos_y(), .5, .5, 0, c_white, 1);

if cherub_draw { 
    var yy = target_actor.y - target_actor.myheight + (party_isup(target_member_name) ? 0 : 20) + 5;
    
    draw_sprite_ext((spamton_variant ? spr_eff_revivesong_cherub_spamton : spr_eff_revivesong_cherub), cherub_index, x + 4, yy, 1, 1, 0, c_white, 1);
    draw_sprite_ext((spamton_variant ? spr_eff_revivesong_cherub_peeved : spr_eff_revivesong_cherub), cherub_index, x - 4, yy, -1, 1, 0, c_white, 1);
}