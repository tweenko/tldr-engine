if global.console 
    exit

if !skipping 
	event_user(5)
else 
	while skipping
		event_user(5)

timer ++