draw = 1
mode = 0 // 0 for text or heal/damage, 1 for enemy heal/damage, 2 for percent, 3 for recruit
user = "kris"

stretch = .2
xoff = 0

// adjust the position to be rendered on the gui layer
x -= guipos_x()
y -= guipos_y()
x *= 2
y *= 2

alarm[0] = 1 // animate

align = 0 // 1 for right