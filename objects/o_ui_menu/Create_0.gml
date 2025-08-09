if instance_exists(get_leader())
	get_leader().moveable_menu = false

menuroll = 0
close = false
timer = 80
surf = -1

selection = 0

// item
i_pselection = 0
i_selection = 0
i_pmselection = 0

// equip
e_pmselection = 0
e_pselection = 0
e_selection = 0

// power
p_pmselection = 0
p_selection = 0

partyreaction = array_create(party_getpossiblecount(), 0)
partyreactiontimer = array_create(party_getpossiblecount(), 0)
partyreactionlen = 30

state = 0
buffer = 0
e_move = 0
only_hp = false

i_mode = 0 // 1 for everybody

darkdollars = 1120

bcolor = merge_color(c_purple, c_black, 0.7)
bcolor = merge_color(bcolor, c_dkgray, 0.5)

depth = DEPTH_UI.MENU_UI