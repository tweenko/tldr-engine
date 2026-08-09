event_inherited();

instance_destroy(o_gb_bullet_lodestar_nova);
instance_destroy(o_gb_bullet_lodestar_razor);
cutscene_stop(current_cutscene);

var inst = enemy_struct.actor_id;
animate(inst.shake, 0, 20, "linear", inst, "shake");
inst.image_speed = 1;