global.last_room = -1;

/// @desc a constructor for adding chapter options to the chapter select menu
/// @arg {string} _name the name of the chapter. will be localized, if applicable
/// @arg {Asset.GMSprite} _icon the chapter's icon
/// @arg {Asset.GMSound} _sound the sound that's going to play on chapter selection
/// @arg {real} _target_chapter the chapter number you'll load into
/// @arg {Asset.GMRoom} _default_room the room the chapter will start in in a fresh save
/// @arg {function} _set_defaults_method the method for setting the defaults
///@arg {Asset.GMSprite} _icon_completed the chapter's icon upon completion
function chapter_option(_name, _icon, _sound, _target_chapter, _default_room, _set_defaults_method = function() {}, _icon_completed=_icon) constructor {
    name = _name;
    icon = _icon;
	icon_completed = _icon_completed;
    sound = _sound;
    target_chapter = _target_chapter;
    target_room = _default_room;
    set_defaults = _set_defaults_method;
    
	intro_seq_default = o_intro_legend;
	intro_seq_first_run = o_ex_intro_tldr;
	intro_seq_midgame = -1;
	
    exec = method(self, function(caller) {
        cutscene_create();

        cutscene_func(music_stop_all);
        cutscene_audio_play(sound);
        cutscene_animate(0, 1, 20, "linear", caller, "trans_shrink")
        cutscene_sleep(80);

        cutscene_func(method({caller, set_defaults, target_room, target_chapter, intro_seq_default, intro_seq_first_run, intro_seq_midgame}, function() {
            global.chapter = target_chapter;
            
            save_entry_set_default("ROOM", target_room);
            save_entry_set_default("CHAPTER", target_chapter);
            set_defaults();
            
            save_reload();
			
			// determine right intro sequence
			var _introseq = intro_seq_default;
			
			var _anySaves = save_exists(0) || save_exists(1) || save_exists(2);
			var _anyCompletedSave = false;
			
			for (var i=0; i<SAVE_SLOTS; i++) {
				if caller.save_chs[global.chapter-1] != -1 && caller.save_chs[global.chapter-1][i] != -1 {
					_anyCompletedSave += caller.save_chs[global.chapter-1][i][1];
					_anyCompletedSave = min(_anyCompletedSave, 1);
				}
			}
	
			if _anySaves {
				if !_anyCompletedSave {
					_introseq = object_exists(intro_seq_midgame) ? intro_seq_midgame : intro_seq_default;
				}
			}
			else {
				_introseq = object_exists(intro_seq_first_run) ? intro_seq_first_run : intro_seq_default;	
			}
				
			room_instance_clear(room_intro);
			room_goto(room_intro);
			
			cutscene_create(false);
			cutscene_wait_until(function(){return room == room_intro});
			cutscene_func(function(_i){
				if !instance_exists(_i) {
					with instance_create(_i) {
						__intro_init();
					}
				}
			}, _introseq);
			cutscene_play();
        }))
		
        cutscene_play();
    });
}