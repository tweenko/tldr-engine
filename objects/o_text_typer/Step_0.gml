if global.console 
    exit

if !skipping 
	event_user(5)
else 
	while skipping && superskipping_buffer == 0
		event_user(5)

timer ++
if superskipping_buffer > 0
    superskipping_buffer --