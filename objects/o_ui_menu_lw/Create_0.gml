if instance_exists(get_leader()){
	get_leader().moveable_menu=false
}

yy = 0
state = 0

selection = 0

ip_selection = 0
i_selection = 0

options=[
	{
		name: "ITEM",
		selectable: (item_get_count(6) == 0 ? false : true),
		state: 1,
	},
	{
		name: "STAT",
		selectable: true,
		state: 3,
	},
	{
		name: "CELL",
		selectable: true,
		state: 4,
	},
]