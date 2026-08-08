event_inherited();

enemy_struct.actor_id.sprite_index = enemy_struct.s_idle
animate(enemy_struct.actor_id.x, save_x, 5, anime_curve.linear, enemy_struct.actor_id, "x");
animate(enemy_struct.actor_id.y, save_y, 5, anime_curve.linear, enemy_struct.actor_id, "y");