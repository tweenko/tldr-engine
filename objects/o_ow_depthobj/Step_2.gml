depth = (is_real(depth_override) ? depth_override : -2000 - y)

if instance_exists(get_leader())
    collide = (get_leader().pf_enabled ? collide_while_plat : collide_ow);