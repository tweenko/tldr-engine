alarm[1] = 1

m_buttons = [
	{
		name: loc("save_menu_save"),
		on: true,
		page: 1
	},
	{
		name: loc("save_menu_return"),
		on: true,
		page: -1,
	},
	{
		name: loc("save_menu_storage"),
		on: true,
		page: 2,
	},
	{
		name: loc("save_menu_recruits"),
		on: false,
		page: 0,
	},
]

m_selection = 0
s_selection = global.save_slot
s_o_selection = 0

st_selection = [0, 0]
st_page = 0
st_stpage = 0
st_maxstpage = 2

st_soulx = 155 - 15
st_souly = 145 + floor(st_selection[st_page]/2)*20 + 3

page = 0

prog = 0
buffer = 0