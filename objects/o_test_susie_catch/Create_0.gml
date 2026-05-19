// Inherit the parent event
event_inherited();

image_speed = 0;
image_index = 0;

image_alpha = 1;

// super duper condensed code
trigger_code = function() {
	if (!instance_exists(_THROW_SNAP()))
		exit;
	
	var _leader = get_leader();
	
	// var _cached_sprite        = get_leader().sprite_index;
	var _old_leader_alpha = _leader.image_alpha;
	_leader.image_alpha   = 0;
	
	image_speed = 1;
	image_index = 2;
	
	var _c = cutscene_create(1);
	var _s_num = sprite_get_number(sprite_index);
	
	cutscene_wait_until(function(s) {
		if ((image_index | 0) >= s - 3) {
			image_index = s - 1;
			image_speed = 0;
			return true;
		}
	}, [_s_num]);
	
	cutscene_func(function(n, l) {
		throw_jump();
		l.image_alpha = n;
	}, [_old_leader_alpha, _leader]);
	
	cutscene_sleep((throw_duration | 0) + 1);
	
	cutscene_func(function() {
		image_speed = 0;
		image_index = 0;
	});
	
	cutscene_play(_c);
};