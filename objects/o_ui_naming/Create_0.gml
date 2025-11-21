caller = noone

naming_text = noone
keyboard = [
    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"],
    ["K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"],
    ["U", "V", "W", "X", "Y", "Z", "BACK", "END"],
]
keyboard_back_pos = [2, 6]
keyboard_end_pos = [2, 7]

keyboard_origin_x = 136
keyboard_origin_y = 140
keyboard_spacing = 26
keyboard_alpha = 0
keyboard_maxchars = 12

selection = [0, 0]
soul_update = false
name = ""
name_angle = 0
name_trans = 0
state = NAMING_STATE.NAMING

confirm_selection = -1
confirm_soulx = 320
confirm_soulx_display = 320
confirm_alpha = 0

target_save_index = 0

enum NAMING_STATE {
    NAMING,
    TRANS_CONFIRM,
    CONFIRM,
    START_SAVE
}

__determine_soul_x = function(i, j) {
    draw_set_font(loc_font("main"))
    
    var __cur_xoff = 0
    for (var k = 0; k < j; k ++) {
        var char = keyboard[i][k]
        __cur_xoff += string_width(char)*2 + keyboard_spacing
    }
    
    return keyboard_origin_x + __cur_xoff + string_width(keyboard[i][j]) - 1
}
__determine_soul_y = function(i, j) {
    return keyboard_origin_y + i*40 + 16
}

keyboard_pos = [] // pre calculate all the soul positions

draw_set_font(loc_font("main"))
for (var i = 0; i < array_length(keyboard); i ++) {
    keyboard_pos[i] = []
    for (var j = 0; j < array_length(keyboard[i]); j ++) {
        keyboard_pos[i][j] = [
            __determine_soul_x(i, j),
            __determine_soul_y(i, j),
            string_width(keyboard[i][j]),
            string_height(keyboard[i][j]),
        ]
    }
}

soulx = keyboard_pos[selection[0]][selection[1]][0]
souly = keyboard_pos[selection[0]][selection[1]][1]
soulx_display = soulx
souly_display = souly

__selection_move = function(di, dj) {
    var snap = 15
    var inc = 5
    
    var __soulx = soulx
    var __souly = souly
    
    var iterations = 0
    while iterations < 20 {
        for (var i = 0; i < array_length(keyboard_pos); i ++) {
            for (var j = 0; j < array_length(keyboard_pos[i]); j ++) {
                var leftbord = keyboard_pos[i][j][0] - keyboard_pos[i][j][2] - snap
                var rightbord = keyboard_pos[i][j][0] + keyboard_pos[i][j][2] + snap
                var topbord = keyboard_pos[i][j][1] - keyboard_pos[i][j][3] - snap
                var bottombord = keyboard_pos[i][j][1] + keyboard_pos[i][j][3] + snap
                
                if __soulx > leftbord && __soulx < rightbord
                    && __souly > topbord && __souly < bottombord
                    && !(i == selection[0] && j == selection[1])
                {
                    selection = [i, j]
                    return true
                }
            }
        }
        __souly += di*inc
        __soulx += dj*inc
        
        iterations ++
    }
}
__create_text = function(text) {
    instance_destroy(naming_text)
    naming_text = instance_create(o_text_typer, 320 + 6, 40, -999, {
        text: "{preset(god_text)}{xspace(1.5)}{instant}" + text + "{stop}",
        gui: true,
        center_x: true,
    })
}
__create_text(loc("naming_menu_txt_enter"))

__cancel = function() {
    if string_length(name) == 0
        instance_destroy()
    else 
        name = string_delete(name, string_length(name), 1)
}