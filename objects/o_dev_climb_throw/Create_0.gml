// Inherit the parent event (o_trigger)
event_inherited();

image_alpha = 0;

//------------------
// Note: I modified the o_dev_climb_controller for this
//       although, fortunately, I have kept a back up!
//       just in case.
//------------------

_THROW_DEBUG = function(n) {
	show_debug_message(
		string("o_dev_climb_throw :: {0}", n)
	);
};

_THROW_SNAP = function() {
	var _snap_tile = instance_nearest(target_x, target_y, o_dev_climb_tile);
	
	if (!instance_exists(_snap_tile)) {
		// silent abortion
		// okay that sounds cruel
		_THROW_DEBUG("bad block");
		return false;
	}
	
	return _snap_tile;
};

///@deprecated Old hardcoded movement
_THROW_LOCK_MOVEMENT = function(n = 1) {
	o_dev_climb_controller.leader_attached = n;      // tell controller we are anchored
	o_dev_climb_controller.leader_spd_y    = 0;      // kill any built-up gravity speed
	o_dev_climb_controller.leader_in_trans = n;      // leader in trans? not moving? idk
	o_dev_climb_controller.__unqueue_calls();
};

throw_jump = function() {
	if (marker >= 0) {
		var mark = marker_get(MARKER_TYPE_CATCH, marker);
		with(mark) {
			other.target_x = x;
			other.target_y = y;
		}
	}
	
	if (!climb_check()) {
		_THROW_DEBUG("not climbing");
		exit;
	}
	
	// block re-entry while a throw (or any climb transition) is already in progress
	if (o_dev_climb_controller.leader_in_trans) {
		exit;
	}
	
	// snap
	var _snap_tile = _THROW_SNAP();
	
	var _dest_x = _snap_tile.x;
	var _dest_y = _snap_tile.y + 2;    // standard offset (+2)
	var _spd    = throw_duration;      // Duration in frames
	
	// dust burst
	for(var _=0; _<5; _++) {
		instance_create(o_eff_generic,
			get_leader().x + random_range(-7, 7),
			get_leader().y + random_range(-7, 7),
			get_leader().depth + 20, {
				sprite_index : spr_eff_climb_dust,
				image_speed  : 1,
				end_alpha    : 1,
				life         : 8,
				vspeed       : -0.25,
			}
		);
	}
	
	// launch sound
	audio_stop_sound(snd_wing);
	audio_play(snd_wing, false, .7, .6 + random(.3));
	
	// animate
	cutscene_create();
	cutscene_player_canmove(false); // whenever you call a `cutscene_` function it adds an action to the current cutscene queue. check out the JSDoc for individual ones for more info
	
	// animation
	cutscene_actor_move(get_leader(), new actor_movement_jump_into(_dest_x, _dest_y, _param_def, _spd));
	cutscene_set_variable(get_leader(), "sprite_index", get_leader().s_climb);
	
	cutscene_player_canmove(true);
	cutscene_play();
	
	// restore idle climb sprite
	o_dev_climb_controller.__queue_call(_spd, method(o_dev_climb_controller, function() {
		get_leader().sprite_index = get_leader().s_climb;
		get_leader().image_index  = 0;
		get_leader().image_speed  = 0;
		leader_in_trans           = false;
	}));
	
	// landing
	o_dev_climb_controller.__queue_call(_spd, function() {
		audio_play(snd_noise, false, .7, 1);
	});
};

trigger_code = throw_jump; // default

// config
target_x       = x;         // X pixel coord of the intended landing tile
target_y       = y;         // Y pixel coord of the intended landing tile
throw_duration = 40;        // throw duration (currently not yet available)
tween_x_off    =  1;        // x tween offset! I do not know when you'll need this
override_fall = true;

// marker support
marker = -1;

// trigger config
can_repeat  =  1;
