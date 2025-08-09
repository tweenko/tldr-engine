/// @description Trigger Entered
event_inherited()
target = get_leader()

if instance_exists(target) 
	follow_save = target.follow
if instance_exists(target) 
	target.slideinst = id

with target {
	sprite_index = s_slide
	s_override = true
	sliding = true
}

audio_play(snd_noise)
snd = audio_play(snd_paper_surf,1)