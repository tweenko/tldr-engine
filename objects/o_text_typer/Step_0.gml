if global.console 
    exit

if !skipping 
	event_user(5)
else 
	while skipping && superskipping_buffer == 0
		event_user(5)

timer ++
box_init = true
if superskipping_buffer > 0
    superskipping_buffer --