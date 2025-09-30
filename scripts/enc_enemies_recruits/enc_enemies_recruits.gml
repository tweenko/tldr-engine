function enemy_recruit(data = {progress: 0}) constructor {
    progress     = data.progress
    need         = 2
    
    name         = "Test"
    desc         = "Description"
    sprite       = spr_default
    spr_speed    = 1
    bgcolor      = c_gray
    chapter      = 0
    
    level        = 0
    element      = "NONE:DEBUG"
    like         = "(None)"
    dislike      = "(None)"
    attack       = 0
    defense      = 0
    
    _data = data
    _prepare_for_export = function() {
        _data = {
            progress: progress
        }
    }
}

function enemy_recruit_virovirokun(data = {progress: 0}) : enemy_recruit(data) constructor {
    need         = 4
    
    sprite       = spr_e_virovirokun_idle
    bgcolor      = c_aqua
    chapter      = 2
    
    level        = 7
    attack       = 8
    defense      = 6
    
    recruit_localize("enemy_virovirokun_recruit")
}
function enemy_recruit_killercar(data = {progress: 0}) : enemy_recruit(data) constructor {
    need         = 1
    
    sprite       = spr_e_killercar
    bgcolor      = c_orange
    chapter      = 6
    
    level        = 12
    attack       = 11
    defense      = 7
    
    name         = "Killer Car"
    desc         = "A dangerous beast of the land of Heretics. Found in tribes, and is usually the one leading them."
    element      = "POWER:COOL"
    like         = "HANGING WITH THE COOL KIDS"
    dislike      = "YOU"
}