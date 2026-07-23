/// @desc This is a constructor used to add chapter options to the chapter select menu (in `global.registered_chapters`).
/// @arg {string} _name The chapter's name or localization code, if applicable.
/// @arg {Asset.GMSprite} _icon The chapter's default icon.
/// @arg {Asset.GMSound} _sound The sound that's going to play upon chapter selection.
/// @arg {real} _target_chapter The chapter number you'll load into.
/// @arg {Asset.GMRoom} _default_room The room the chapter will start in on a fresh save.
/// @arg {Asset.GMObject} _intro_seq_first_run The intro sequence object that's going to play if you have no saves on that chapter. (-1 (none) by default)
/// @arg {Asset.GMObject} _intro_seq_midgame  The intro sequence object that's going to play if you have no completed saves on that chapter. (-1 (none) by default)
/// @arg {Asset.GMObject} _intro_seq_default The intro sequence object that's going to play if you have any completed saves on that chapter, or if the previous intro sequences have not been defined. (`o_intro_legend` by default)
/// @arg {Real} _save_theme_default The theme to use for room_save_select while the chapter isn't completed. (`SAVE_SELECT_THEME.GREAT_DOOR` by default)
/// @arg {Real} _save_theme_completed The theme to use for room_save_select if the chapter is completed. (`SAVE_SELECT_THEME.FOUNTAIN` by default)
/// @arg {function} _set_defaults_method The method for setting the defaults. (Empty function by default)
/// @arg {Asset.GMSprite} _icon_completed The chapter's icon if it's been completed. (same as `_icon` by default)
function chapter_option(_name, _icon, _sound, _target_chapter, _default_room, _intro_seq_firstrun=-1, _intro_seq_midgame=-1, _intro_seq_default = o_intro_legend, _save_theme_default=SAVE_SELECT_THEME.GREAT_DOOR, _save_theme_completed=SAVE_SELECT_THEME.FOUNTAIN, _set_defaults_method = function() {}, _icon_completed=_icon) constructor {
    name = _name;
    icon = _icon;
	icon_completed = _icon_completed;
    sound = _sound;
    target_chapter = _target_chapter;
    target_room = _default_room;
    set_defaults = _set_defaults_method;
    
	intro_seq_default = _intro_seq_default;
	intro_seq_first_run = _intro_seq_firstrun;
	intro_seq_midgame = _intro_seq_midgame;
	
	save_theme_default = _save_theme_default;
	save_theme_completed = _save_theme_completed;
	
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