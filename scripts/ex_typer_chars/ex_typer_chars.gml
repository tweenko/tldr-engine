/// @desc init for the typer characters
function ex_typer_gerson() : typer_char() constructor {
    name = "gerson"
    
    voice = snd_ex_text_gerson
    voice_skip = 3
    voice_pitch_calc = function() {
        if irandom(2) == 2
            return 1 - random(.2)
        
        return 1
    }
}