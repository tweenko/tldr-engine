///@desc returns the party leader at the moment
function get_leader(){
	return party_get_inst(global.party_names[0])
}

///@desc creates an actor standing in for the party leader
function party_leader_create(name, xx, yy, ddepth){
	var pl = actor_create(party_get_obj(name), xx, yy, ddepth)
	o_camera.target = pl.id
	
	pl.is_player = true
	with pl 
		event_user(2)
	party_setdata(name, "actor_id", pl)
	
	return pl
}

///@desc creates an actor standing in for the party member
function party_member_create(name, recordnow = true, xx = get_leader().x, yy = get_leader().y){
	var inst = actor_create(party_get_obj(name), xx, yy, get_leader().depth)
	inst.is_follower = true
	inst.pos = get_leader().spacing * party_getpos(name)
	
	with inst {
		if recordnow 
			event_user(1)
		event_user(2)
		init = true
	}
	party_setdata(name, "actor_id", inst)
	
	return inst
}

///@desc interpolates the party position to attach them back to the "caterpillar"
function party_member_interpolate(name){
	if !instance_exists(party_get_inst(name)) 
		exit
    
	with party_get_inst(name) {
		var ddir = actor_angletodir(point_direction(x, y, get_leader().x, get_leader().y))
		record[0][0] = get_leader().x
		record[1][0] = get_leader().y
		record[2][0] = get_leader().dir
		
		for (var i = pos; i > 0; i -= 1)
		{
			record[0][i] = lerp(get_leader().x, x, (i / pos))
			record[1][i] = lerp(get_leader().y, y, (i / pos))
			record[2][i] = ddir
			record[3][i] = false
		}
	}
}

///@desc recalculates the position of the party members
function party_reposition(lx = get_leader().x, ly = get_leader().y){
	var ddepth = get_leader().depth
	
	if instance_exists(party_get_inst(global.party_names[0])) {
		var pl = party_get_inst(global.party_names[0])
		
		pl.x = lx
		pl.y = ly
		
		o_camera.target = pl.id
		
		pl.is_player = true
		with pl 
			event_user(2)
	}
	for (var i = 1; i < array_length(global.party_names); ++i) {
		if instance_exists(party_get_inst(global.party_names[i])) {
			var inst = party_get_inst(global.party_names[i])
			inst.is_follower = true
			inst.pos = get_leader().spacing * party_getpos(global.party_names[i])
			
			with inst { // set position, initialize the followers
				if array_length(record) == 0 
					event_user(1)
				
				x = record[0][pos]
				y = record[1][pos]
				dir = record[2][pos]
				
				event_user(2)
				init = true
			}
		}
	}
	//party_interpolate()
}

///@arg {string} _name
function party_ismember(_name) {
	return array_contains(global.party_names, _name)
}

/// @desc sets the state of a party member (sprite state)
/// @arg {string} _name
/// @arg {string} _state 
function party_set_state(_name, _state) {
    party_setdata(_name, "s_state", _state)
    
    with party_get_inst(_name)
        event_user(2)
}