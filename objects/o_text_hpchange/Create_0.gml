enum TEXT_HPCHANGE_MODE {
    PARTY = 0, 
    ENEMY = 1,
    PERCENTAGE = 2, 
    RECRUIT = 3,
    SCALE = 4
}

draw = 1
mode = TEXT_HPCHANGE_MODE.PARTY
user = "kris"

stretch = .2
xoff = 0

// adjust the position to be rendered on the gui layer
x -= guipos_x()
y -= guipos_y()
x *= 2
y *= 2

while instance_place(x+9, y+6, o_text_hpchange)
    y += 22

visual_x = x
visual_y = y

x += 9; y += 6
depth = -2000-y

alarm[0] = 1 // animate

align = 0 // 1 for right