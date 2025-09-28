function enemy_recruit() constructor {
    progress     = 0
    need         = 2
    
    name         = "Test"
    desc         = "Description"
    sprite       = spr_e_virovirokun_idle
    spr_speed    = 1
    bgcolor      = c_aqua
    chapter      = 2
    
    level        = 0
    element      = "NONE:DEBUG"
    like         = "(None)"
    dislike      = "(None)"
    attack       = 0
    defense      = 0
}

function enemy_recruit_virovirokun() : enemy_recruit() constructor {
    need         = 4
    
    sprite       = spr_e_virovirokun_idle
    bgcolor      = c_aqua
    chapter      = 2
    
    level        = 7
    attack       = 8
    defense      = 6
    
    recruit_localize("enemy_virovirokun_recruit")
}