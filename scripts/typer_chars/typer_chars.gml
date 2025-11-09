/// @desc init for the typer characters
function typer_chars_init()  {
    new typer_char_none().__initialize()
    new typer_char_susie().__initialize()
    new typer_char_susie_bangs().__initialize()
    new typer_char_ralsei().__initialize()
    new typer_char_ralsei_hat().__initialize()
    new typer_char_noelle().__initialize()
}
/// @desc creates a struct with a typer character
function typer_char() constructor {
    name = "none" // the hash of the typer char
    face_sprite = noone // the face sprite
    
    face_create = function(_x, _y, _depth) {
        if !sprite_exists(face_sprite)
            return noone
        
        var inst = instance_create(o_text_face, _x, _y, _depth)
        inst.f_sprite = face_sprite
        
        return inst
    }
    
    voice = snd_text // the voice sound
    voice_pitch_calc = 1 // the pitch of the voice (could be either a function or a real number)
    voice_interrupt = false // whether to stop the voice sound every time a new blip is played
    voice_skip = 1 // every (how many?) frames to play the sound
    
    /// @desc initialize the typer char - add to the typer's char presets
    __initialize = method(self, function(typer) {
        struct_set(global.typer_chars, name, self)
    })
}

// -------------------- child constructors --------------------

function typer_char_none() : typer_char() constructor {
}

function typer_char_susie() : typer_char() constructor {
    name = "susie"
    
    face_sprite = spr_face_susie
    voice = snd_text_susie
}
function typer_char_susie_bangs() : typer_char() constructor {
    name = "susie_bangs"
    
    face_sprite = spr_face_susie_bangs
    voice = snd_text_susie
}

function typer_char_ralsei() : typer_char() constructor {
    name = "ralsei"
    
    face_sprite = spr_face_ralsei
    voice = snd_text_ralsei
}
function typer_char_ralsei_hat() : typer_char() constructor {
    name = "ralsei_hat"
    
    face_sprite = spr_face_ralsei_hat
    voice = snd_text_ralsei
}

function typer_char_noelle() : typer_char() constructor {
    name = "noelle"
    
    face_sprite = spr_face_noelle
    voice = snd_text_noelle
}