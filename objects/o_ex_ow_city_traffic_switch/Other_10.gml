audio_play(snd_noise)
if active{
	active=false
	timer_sec=0
	timer=0

	var t=time
	var tgt=switch_id
	with(o_ex_ow_city_traffic_switch){
		if switch_id==tgt{
			active=false
			timer_sec=time
			timer=0
		}
	}
}else{
	active=true
	timer_sec=time
	timer=0


	var t=time
	var tgt=switch_id
	with(o_ex_ow_city_traffic_switch){
		if switch_id==tgt{
			active=true
			timer_sec=time
			timer=0
		}
	}
}