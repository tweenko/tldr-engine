event_inherited()

s_hurt = spr_e_virovirokun_hurt	
s_spared = spr_e_virovirokun_spare

is_enemy = true
chase_encounter = false

// idle_path, idle_path_spd, idle_path_autodir, sprite_facing_dir configured in variable difinitions
// chase_zone, chase_zone_auto, chase_dist and chase_spd are configured in variable definitions
// idle_path_autopos will make it so the enemy is snapped to the closest point on the path its linked to.
// idle_path_manualpos_optional will be the position on the path if the autopos is declined

chasing = false
notice_timer = -1
notice = false

// visual animation
drawsiner = 0
// the encounter that would be initialized upon collision is in variable definitions
encounter_started = false

__start_chasing = function() {
    notice_timer = 0
    audio_play(snd_exclamation)
    
    if !is_undefined(idle_path)
        path_end()
    
    chase_encounter = true
}

xprev_real = 0