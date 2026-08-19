caller = -1

fighting = []
targets = []
pattern = []
sticks = []
fighterselection = [] // the attack target
enemy_hp = []


ui_fightarea_x = 79;
ui_fightarea_y = 365;
ui_fightarea_height = 114;

ui_fightbar_width = 125;
ui_fightbar_height = ui_fightarea_height / max(3, party_length());

ui_crit_x = 82;
ui_crit_widths = array_create(party_length(), 20);


order = 0
lightup = 0
buffer = 0
diestate = 0

alarm[0] = 1