if instance_exists(get_leader())
	get_leader().moveable_menu = false

yy = 0
state = 0

selection = 0
dialogue_overlay = false

ip_selection = 0
i_selection = 0

c_selection = 0

options = [
	{
		name: "ITEM",
		selectable: (item_get_count(ITEM_TYPE.LIGHT) == 0 ? false : true),
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

phone_numbers = [
    {
        name: "Call Home",
        cutscene: function() {
            cutscene_create()
            cutscene_dialogue([
                "{preset(light_world)}{sound(snd_phone)}* (Ring, ring...)",
                "* (Ring, ring...)",
                "* (..?)",
                "* (Your call was redirected to a contact named Berdly.)",
                "{choice(Decline, Decline)}{c}* (Click...)",
            ])
            cutscene_func(instance_destroy, o_ui_menu_lw)
            cutscene_play()
        }
    }
]
phone_can_use = true
phone_cant_cutscene = function() {
    cutscene_create()
    cutscene_dialogue([
        "{preset(light_world)}* (You checked your phone's contacts and recent dials.)",
        "* (... but everything has been deleted.)"
    ])
    cutscene_func(instance_destroy, o_ui_menu_lw)
    cutscene_play()
}