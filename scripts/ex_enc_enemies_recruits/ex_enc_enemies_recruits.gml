function ex_enemy_recruit_shadowguy(data = {progress: 0}) : enemy_recruit(data) constructor {
    need         = 4
    
    name         = "Shadowguy"
    desc         = "Passionate about music, but\noften taken advantage of by\nsinister types."
    sprite       = spr_ex_e_sguy_idle
    spr_speed    = 1
    bgcolor      = c_green
    chapter      = 3
    
    level        = 18
    element      = "CHAOS:MUSIC"
    like         = "Creative"
    dislike      = "Business"
    attack       = 13
    defense      = 13
}