event_inherited();

instance_destroy(o_ex_bullet_dentos_eye)
instance_destroy(o_ex_bullet_dentos_diamond)
instance_destroy(current_cutscene)

var inst = enemy_struct.actor_id
do_animate(inst.shake, 0, 20, "linear", inst, "shake")
inst.image_speed = 1