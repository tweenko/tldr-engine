event_inherited()

if is_enemy && freeze > 0 {
    image_speed = 0
    sprite_index = s_hurt
    
    exit
}

drawsiner += 0.25

if !is_undefined(chase_dist) && !chasing && notice_timer == -1 {
    if distance_to_point(get_leader().x, get_leader().y) < chase_dist {
        __start_chasing()
    }
}
if notice_timer >= 0
    notice_timer ++

if notice_timer >= 0 && notice_timer < 30
    notice = true
else
    notice = false

if notice_timer == 30
    chasing = true

if chasing && !is_in_battle
	&& instance_exists(get_leader()) 
	&& get_leader()._checkmove() 
{
	var xx = dcos(point_direction(x, y, get_leader().x, get_leader().y))
	var yy = -dsin(point_direction(x, y, get_leader().x, get_leader().y))
	
	// the direction of the movement that is determined by the xx and yy
	var rx = xx * chase_spd
	var ry = yy * chase_spd
	
	if (!place_meeting(x + rx, y, o_block) 
	|| (instance_place(x + rx, y, o_block) != noone && !instance_place(x + rx, y, o_block).collide))
    && (!instance_exists(chase_zone) || place_meeting(x + rx, y, chase_zone))
		x += rx
	if (!place_meeting(x, y + ry, o_block) 
	|| (instance_place(x, y + ry, o_block) != noone && !instance_place(x, y + ry, o_block).collide))
    && (!instance_exists(chase_zone) || place_meeting(x, y + ry, chase_zone))
		y += ry
		
	// diagonal collision
	if place_meeting(x + xx, y, o_block_diag) 
		y += sign(instance_place(x + xx, y, o_block_diag).image_yscale) * chase_spd
	if place_meeting(x,y + yy, o_block_diag)
		x += sign(instance_place(x, y + yy, o_block_diag).image_xscale) * chase_spd
}

// collision, initiate encounter
if place_meeting(x, y, get_leader()) 
    && !encounter_started && (can_idle_encounter || chase_encounter) 
    && !instance_exists(o_enc) && !instance_exists(o_enc_anim) 
{
    chasing = false
    encounter_started = true
    hurt = 20
    
    path_end()
    encounter._start()
    
    image_xscale = 1
}