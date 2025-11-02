naming_text = noone
keyboard = [
    ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"],
    ["K", "L", "M", "N", "O", "P", "Q", "R", "S", "T"],
    ["U", "V", "W", "X", "Y", "Z", "BACK", "END"],
]
keyboard_origin_x = 136
keyboard_origin_y = 140
keyboard_spacing = 26

selection = [0, 6]
soulx = 0
souly = 0
soulx_display = 0
souly_display = 0
soul_update = true

if !instance_exists(naming_text) {
    //naming_text = instance_create(o_text_typer, 320, 40, -999, {
        //text: "{preset(god_text)}{xspace(2)}{instant}THIS IS YOUR NAME.{stop}",
        //gui: true,
        //center_x: true,
    //})
    naming_text = instance_create(o_text_typer, 320 + 6, 40, -999, {
        text: "{preset(god_text)}{xspace(1.5)}{instant}ENTER YOUR OWN NAME.{stop}",
        gui: true,
        center_x: true,
    })
}

__determine_soul_x = function(i, j) {
    var __cur_xoff = 0
    for (var k = 0; k < i; k ++) {
        __cur_xoff += string_width(keyboard[i][k])*2 + keyboard_spacing
    }
    
    return keyboard_origin_x + __cur_xoff + 6
}
__determine_soul_y = function(i, j) {
    return keyboard_origin_y + i*40 + 16
}
