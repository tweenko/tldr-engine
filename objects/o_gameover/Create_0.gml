state = 0
timer = 0

freezeframe = -1
freezeframe_gui = -1

ui_alpha = 0
fader_alpha = 0
inst_dialogue = noone
dia_created = false
confirm_pressed = 0

selection = -1
soulx = 320
souly = 360 + 20
choice = [loc("game_over_continue"), loc("game_over_give_up")]

_dialogue = undefined
var dialogue_variants = []

if party_contains("susie")
    array_push(dialogue_variants, loc("game_over_dialogue_susie"))
if party_contains("ralsei")
    array_push(dialogue_variants, loc("game_over_dialogue_ralsei"))

if array_length(dialogue_variants) > 0
    _dialogue = array_shuffle(dialogue_variants)[0]

image_alpha = 0