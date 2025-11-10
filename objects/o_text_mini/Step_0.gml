if is_undefined(face_creator)
    instance_destroy()

if x_offset > 0
    x_offset -= 10

if !instance_exists(face_inst) {
    face_inst = face_creator(x + x_offset, y - 6, depth-100) 
    
    face_inst.f_index = face_expression
    face_inst.visible = true
}

x = xstart + x_offset
image_alpha += .2

face_inst.image_alpha = image_alpha
face_inst.x = xstart + x_offset