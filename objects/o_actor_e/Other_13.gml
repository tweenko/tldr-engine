/// @desc find closest chase zone if automatic
if chase_zone_auto && instance_exists(o_trigger_enemy_chase) {
    chase_zone = instance_nearest(x, y, o_trigger_enemy_chase)
    chase_zone.target_enemy_instance = id
}
if !is_undefined(chase_dist) && instance_exists(chase_zone) {
    chase_zone.chase_mode = 1
}