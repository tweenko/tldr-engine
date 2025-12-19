choices = ["Yes", "No"]

caller = -1
selection = -1
on = false
xx = 0

x -= 26
y -= 20

alarm[0]=2

cant_left = 0
cant_right = 0
if instance_exists(o_cutscenes)
{
    if o_cutscenes.cant_right = 1 cant_right = 1
    if o_cutscenes.cant_left = 1 cant_left = 1
}
    
shake = 0
shake_x = 0