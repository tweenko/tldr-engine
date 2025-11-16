event_inherited()
collide = false

name = ""
state = -1

// actor type
is_enemy = false
is_follower = false
is_in_battle = false
is_selected_for_battle = false
is_player = false

{ // player specific
	spd = 2
	runspd = 4
	basespd = spd
	lockeddir = -1
    auto_run = global.settings.AUTO_RUN
	
	slide_vertical_allow = false // can move vertically while sliding
	diagonal = true // can move diagonally
	
	stepsounds = false
	stepsound = 0 // if the stepsound was played
	stepsoundprefix = "snd_step"
	
	spacing = (global.world == WORLD_TYPE.LIGHT ? 15 : 12) // make the party member spacing bigger in the light world
}
{ // enemy specific
	chaser = false
	chasing = false
    
    carrying_money = 0
}
{ // actor variables
	follow = true
	hurt = 0 // the timer of the sprite switch
	
	autoheight = true // whether the height is automatically determined
	myheight = 0
	
	custom_depth = undefined
	pos = 0
    
    /// @desc needs to return true to function
    interaction_code = function() {
        return false
    }
    interaction_args = []
    interactable_instances = []
}
{ // visual
	{ // sprites
		s_auto = true
		s_state = ""
		s_prefix = ""
		s_override = false
		s_dynamic = true
	
		s_move[DIR.UP] = spr_kris_up
		s_move[DIR.DOWN] = spr_kris_down
		s_move[DIR.LEFT] = spr_kris_left
		s_move[DIR.RIGHT] = spr_kris_right
		s_hurt = spr_e_virovirokun_hurt
		s_ball = spr_kris_ball
		s_landed = spr_kris_landed
		s_slide = spr_kris_slide
		s_run_postfix = ""
	
		s_walk_ispd = 1
		s_run_ispd = 2
	}
	
	s_drawer = function(_sprite, _index, _xx, _yy, _xscale, _yscale, _angle, _blend, _alpha) {
		draw_sprite_ext(_sprite, _index, 
			_xx, _yy, 
			_xscale, _yscale, 
			_angle, _blend, _alpha
		)
	}
	
	snapping = 1 // 1 for none
	
	trail = false // afterimage
	flashing = false
	darken = 0
	dim = 0
	sweat = false
	
	yoff = 0
	xoff = 0
	shake = 0
	
    flash_color = c_white
	fsiner = 0 // flash siner
	flash = 0
	
	can_reflect = true
	reflection_code = function() {
		var ret = image_yscale
		image_yscale = -image_yscale
		
		event_perform(ev_draw, ev_draw_normal)
		
		image_yscale = ret
	}
}
{ // internal variables
	move[DIR.UP] = 0
	move[DIR.RIGHT] = 0
	move[DIR.DOWN] = 0
	move[DIR.LEFT] = 0
	
	dir = DIR.DOWN
	
	startedmoving = false
	moving = false
	sprname = ""
	
	run_away = false
	run_away_timer = 0
    
    freeze = 0
    
	running = false
	sliding = false
	prevsliding = false
	slideinst = noone
	
	init = false
	
	record = []
    
    dodge_outline_surf = -1
    dodge_mysoul = noone
    spawn_buffer = 4
}
{ // moveables
	moveable = true // the user-defined one, used in cutscenes and such. not touched by any of the systems in the engine by default
	moveable_dialogue = true
	moveable_menu = true
	moveable_move = true // actor_mover is moving it
	moveable_battle = true
	moveable_console = true
	moveable_save = true
	moveable_anim = true
    moveable_recruits = true
	
	_checkmove = function() { // the main function that determines whether the player can move as of right now
		return moveable 
		&& moveable_dialogue
		&& moveable_menu
		&& moveable_move // actor_mover is moving it
		&& moveable_battle
		&& moveable_console
		&& moveable_save 
		&& moveable_anim 
        && moveable_recruits
		
		&& hurt == 0
        && spawn_buffer <= 0
		
		&& !global.console
	}
}

alarm[0] = 1

if !instance_exists(o_dodge_controller) 
	instance_create(o_dodge_controller)
if !instance_exists(o_lighting_controller)
    instance_create(o_lighting_controller)