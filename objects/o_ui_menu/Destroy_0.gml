if only_hp 
	exit
if instance_exists(get_leader())
	get_leader().moveable_menu = true