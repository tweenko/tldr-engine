if jump_timer < 1
    exit;

var reticle_hint_col_inactive = make_color_rgb(200, 200, 200);
var reticle_hint_col_active = make_color_rgb(255, 200, 132);
var fade_alpha = clamp(jump_timer/10, 0, 1);

var traj_color = reticle_hint_col_inactive;
if instance_exists(jump_target_tile)
    traj_color = reticle_hint_col_active;

var dx = lengthdir_x(10, current_direction);
var dy = lengthdir_y(10, current_direction);

if jump_reach > 4
    draw_sprite_ext(spr_climb_traj_hint, draw_get_index_looped(spr_climb_traj_hint), get_leader().x + dx, get_leader().y + dy - 1, 1, jump_reach / clamp(jump_reach_max, 0, 50), current_direction + 90, traj_color, 0.85 * fade_alpha);

var hint_color = merge_color(c_yellow, c_white, 0.4 + sine(3, .4, jump_reach/2));
var hint_alpha = clamp(sine(14, 1, jump_reach/2), 0.1, 0.8) * fade_alpha;
if instance_exists(jump_target_tile)
    draw_sprite_ext(spr_climb_rect_hint, 0, jump_target_tile.x, jump_target_tile.y, 1, 1, 0, hint_color, hint_alpha);