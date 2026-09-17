// this is a default library for tldr engine
// Ripple v1.0.0
// made by techncolour with polish by tweenko

/// @desc creates a dark ripple
/// @arg {real} x
/// @arg {real} y
/// @arg {real} power
/// @arg {Constant.Colour} colour
/// @arg {real} n_polygons
/// @arg {real} width
/// @arg {real} rotation
/// @arg {Constant.BlendMode} blend_mode
/// @arg {real} thickness
/// @arg {real} choppiness_div the choppiness of the effect (how often it updates - the higher it is, the less often it will)
/// @arg {real} space_out how spaced out circles are. affects the way thickness looks
/// @arg {real} alpha
/// @arg {real} fade_speed
/// @arg {Id.Instance|Asset.GMObject} stick_to_object if an existing instance, will stick the ripple onto it
/// @arg {real} x_off
/// @arg {real} y_off
/// @arg {real} depth
function lb_ripple_create(
	_x, _y, _power = 3, _colour = c_white, _polygons = 24, 
	_width = 3, _rotation = 0, _blendmode = bm_add, _thickness = 14, 
	_choppiness_div = 1, _spaced_out = 1, _alpha = 1, _fade_speed = 0.025, 
	_stick_to_object = noone, _x_off = 0, _y_off = 0,
	_depth = depth + 100
) {
	var inst = instance_create_depth(_x + _x_off, _y + _y_off, _depth, o_lb_ripple);
	with inst {     
		if _polygons < 3
			_polygons = 3;
		if _thickness < _width
			_thickness = _width;
			
		ripple_power = _power;
		thickness = floor(_thickness/_width);
		colour = _colour;
		alpha = _alpha;
		polycount = _polygons;
		width = _width;
		fade_speed = _fade_speed;
		blending = _blendmode;
		choppiness_div = _choppiness_div;
		spaced_out = _spaced_out * _width;
		stick_to_inst = _stick_to_object;
		stick_xoff = _x_off;
		stick_yoff = _y_off;
		depth = _depth;
		image_angle = _rotation;
	};
	
	return inst;
};

function lb_ripple_vision_on() {
	if !instance_exists(o_lb_ripple_vision)
		instance_create(o_lb_ripple_vision);
}
function lb_ripple_vision_off() {
	instance_destroy(o_lb_ripple_vision);
}