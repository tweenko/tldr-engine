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
    SWITCH,
    SINGLE_SLIDER,
}
c_config = [
    {
        name: loc("menu_config_master_vol"),
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
        name: loc("menu_config_controls"),
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            state = 3
        })
    },
    {
        name: loc("menu_config_simplify_vfx"),
        state: function() {
            return global.settings.SIMPLIFY_VFX
        },
        type: C_CONFIG_TYPE.SWITCH,
        call: method(self, function(_bool) {
            global.settings.SIMPLIFY_VFX = _bool
        })
    },
    // fullscreen ?
    {
        name: loc("menu_config_auto_run"),
        state: function() {
            return global.settings.AUTO_RUN
        },
        type: C_CONFIG_TYPE.SWITCH,
        call: method(self, function(_bool) {
            get_leader().auto_run = _bool
            global.settings.AUTO_RUN = _bool
        })
    },
    // border ?
    {
        name: loc("menu_config_return_title"),
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            music_stop_all()
            room_goto(room_save_select)
        })
    },
    {
        name: loc("menu_config_back"),
        type: C_CONFIG_TYPE.BUTTON,
        call: method(self, function() {
            state = 0
        })
    },
]

if !global.can_use_borders {
    array_insert(c_config, 3, {
        name: loc("menu_config_fullscreen"),
        state: function() {
            return window_get_fullscreen()
        },
        type: C_CONFIG_TYPE.SWITCH,
    
        call: method(self, function(_bool) {
            window_set_fullscreen(_bool)
        }),
    })
}
else {
    array_insert(c_config, 5, {
        name: loc("menu_config_border"),
        display: function() {
            return loc($"menu_config_border_mode_{global.border_mode}")
        },
        type: C_CONFIG_TYPE.SINGLE_SLIDER,
    
        call: method(self, function(delta) {
            global.border_mode += delta
            global.border_mode = (global.border_mode + global.border_mode_count) % global.border_mode_count
            
            if global.border_mode == BORDER_MODE.OFF
                borders_toggle(false)
            else
                borders_toggle(true)
            
            if global.border_mode == BORDER_MODE.DYNAMIC
                border_set(global.current_dynamic_border)
            else if global.border_mode == BORDER_MODE.SIMPLE
                border_set(border_simple)
            else if global.border_mode == BORDER_MODE.NONE
                border_set(border_none)
        }),
    })
}


c_controls = [
    INPUT_VERB.DOWN,
    INPUT_VERB.RIGHT,
    INPUT_VERB.UP,
    INPUT_VERB.LEFT,
    INPUT_VERB.SELECT,
    INPUT_VERB.CANCEL,
    INPUT_VERB.SPECIAL,
]
c_controls_changing = false
c_controls_resetfade = 0

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