if image_index == 1
	exit

image_index = 1

audio_play(snd_locker)
screen_shake(5)

var txt = "* (You opened the treasure chest.){s(10)}{br}{resetx}* (Inside was {col(y)}" + item_get_name(item_inside) + "{col(w)}.)" + "{p}{c}"
txt += item_add(item_inside)
dialogue_start(txt)

state_add("chests_open", id)