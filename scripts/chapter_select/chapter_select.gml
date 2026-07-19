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
    
    exec = method(self, function(caller) {
        cutscene_create();

        cutscene_func(music_stop_all);
        cutscene_audio_play(sound);
        cutscene_animate(0, 1, 20, "linear", caller, "trans_shrink")
        cutscene_sleep(80);

        cutscene_func(method({set_defaults, target_room, target_chapter}, function() {
            global.chapter = target_chapter;
            
            save_entry_set_default("ROOM", target_room);
            save_entry_set_default("CHAPTER", target_chapter);
            set_defaults();
            
            save_reload();
            room_goto(room_save_select);
        }))

        cutscene_play();
    });
}