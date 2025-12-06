event_inherited()

bullet_surf = -1

x = 320/2
y = 170/2
depth = DEPTH_ENCOUNTER.BOX;

x += guipos_x()
y += guipos_y()

// customizable
width = 75;
height = 75;
color = c_green;
flash = 0
timer = 0

temp_scale = 0
temp_angle = -180

solid_left = noone
solid_top = noone
solid_right = noone
solid_bottom = noone

is_transitioning = true
trans_sprite = -1
trans_surf = -1
trans_lerp = 0

sprite_w = sprite_get_width(sprite_index)
sprite_h = sprite_get_height(sprite_index)
prev_sprite = sprite_index

drawer = method(self, function(_sprite, _index, _xx, _yy, width, height, angle, _blend, _alpha) {
    var xscale = width / sprite_w
    var yscale = height / sprite_h
    draw_sprite_ext(_sprite, _index, _xx, _yy, xscale, yscale, angle, _blend, _alpha)
})

animate(0, 1, 15, "linear", id, "temp_scale")
animate(-180, 0, 15, "linear", id, "temp_angle")
animate(0, 1, 18, "linear", id, "trans_lerp")

__close = function() {
    timer = 0
    
    is_transitioning = true
    animate(1, 0, 15, "linear", id, "temp_scale")
    animate(0, 180, 15, "linear", id, "temp_angle")
    animate(1, 0, 18, "linear", id, "trans_lerp")
    
    alarm[0] = 15
}