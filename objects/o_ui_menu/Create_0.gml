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

// config
c_selection = 0
c_controls_selection = 0
c_holdtimer = 0

enum C_CONFIG_TYPE {
    SLIDER,
    BUTTON,
    SWITCH
}
c_config = [
    {
        name: "Master Volume",
        type: C_CONFIG_TYPE.SLIDER,
    
        call: method(self, function(delta) {
            o_world.volume_master += delta
            o_world.volume_master = clamp(o_world.volume_master, 0, 1)
        }),
        display: function() {
            return $"{clamp(round(o_world.volume_master * 100), 0, 100)}%"
        }
    },
    {
        name: "Controls",
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            state = 4
        })
    },
    {
        name: "Simplify VFX",
        state: false,
        type: C_CONFIG_TYPE.SWITCH,
        call: method(self, function(_bool) {
            global.simplify_vfx = _bool
        })
    },
    {
        name: "Fullscreen",
        state: false,
        type: C_CONFIG_TYPE.SWITCH,
        call: method(self, function(_bool) {
            window_set_fullscreen(_bool)
        })
    },
    {
        name: "Auto-Run",
        state: false,
        type: C_CONFIG_TYPE.SWITCH,
        call: method(self, function(_bool) {
            get_leader().auto_run = _bool
        })
    },
    {
        name: "Return to Title",
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            music_stop_all()
            room_goto(room_save_select)
        })
    },
    {
        name: "Back",
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            state = 0
        })
    },
]

partyreaction = array_create(party_getpossiblecount(), 0)
partyreactiontimer = array_create(party_getpossiblecount(), 0)
partyreactionlen = 5

state = 0
buffer = 0
e_move = 0
only_hp = false

i_mode = 0 // 1 for everybody

darkdollars = save_get("money")

bcolor = merge_color(c_purple, c_black, 0.7)
bcolor = merge_color(bcolor, c_dkgray, 0.5)

depth = DEPTH_UI.MENU_UI