if lightup > 0
	lightup -= .2

if !InputCheck(INPUT_VERB.SELECT)
	buffer = 0
	
var go = true
for (var i = 0; i < array_length(sticks); ++i) {
    if instance_exists(sticks[i]) 
		go = false
}

if go && diestate == 0 {
	diestate=1 
	alarm[1] = 30
}
if diestate == 2 
	image_alpha-=.1
if image_alpha <= 0 
	instance_destroy()