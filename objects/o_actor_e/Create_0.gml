event_inherited()

s_hurt = spr_e_virovirokun_hurt	
s_spared = spr_e_virovirokun_spare

is_enemy = true

idle_path = undefined
idle_path_spd = 1

chasing = false
chase_spd = 3
chase_zone = noone
chase_zone_auto = true
chase_dist = undefined

notice_timer = -1
notice = false

// visual animation
drawsiner = 0

// the encounter that would be initialized upon collision
encounter = new enc_set_ex()
encounter_started = false

__start_chasing = function() {
    notice_timer = 0
    audio_play(snd_exclamation)
    
    if !is_undefined(idle_path)
        path_end()
}