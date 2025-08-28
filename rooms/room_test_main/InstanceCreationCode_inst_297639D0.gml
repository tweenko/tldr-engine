members = []
name = "party wait"

execute_code = function() {
	cutscene_create()
	cutscene_player_canmove(false)
	cutscene_party_follow(false)
    
    if array_length(global.party_names) == 1 {
        cutscene_dialogue([
            "* (Standing here, you realized something.)",
            "* (If you had any PARTY MEMBERS, you could've asked them to wait here.)",
            "* (Felt like useful information.)",
            "* (Not really...)"
        ])
    }
    
    else if array_length(members) == 0 {
        var _txt = []
        if array_contains(global.party_names, "susie") {
            array_push(_txt, string("{char(susie, 21)}* Want {0} to wait around here? Sure I guess.", (array_length(global.party_names) > 2 ? "us" : "me")))
        }
        if array_contains(global.party_names, "ralsei") {
            array_push(_txt, ["{char(ralsei, 20)}* Huh? Wait here?", 
                "{face_ex(19)}* Sure! Tell me if you need anything!"
            ])
        }
        if array_contains(global.party_names, "noelle") {
            array_push(_txt, "{char(noelle, 27)}* Umm... Well, if you say please, I'll think about it!!")
        }
        
        if array_length(_txt) > 0 
            cutscene_dialogue(array_shuffle(_txt)[0])
        
        var __len = clamp(array_length(global.party_names), 0, 4)
        for (var i = 1; i < __len; i ++) {
            var marker = marker_getpos("test_pm_wait", i)
            var o = party_get_inst(global.party_names[i])
            if instance_exists(o) && !is_undefined(marker) {
                cutscene_actor_move(o, new actor_movement(marker.x, marker.y, 20), i, (i == __len-1 ? true : false))
                cutscene_set_variable(o, "collide", true)
            }
        }
        
        var dialogue = {
            susie: "{char(susie)}* Sup.",
            ralsei: "{char(ralsei)}* That's me, {0}!",
            noelle: "{char(noelle)}* Hi!"
        }
        for (var i = 1; i < __len; i ++) {
            var o = party_get_inst(global.party_names[i])
            o.follow = false
            
            if instance_exists(o) {
                cutscene_set_variable(o, "dir", DIR.UP)
                if struct_exists(dialogue, global.party_names[i]) {
                    if !array_contains(get_leader().interactable_instances)
                        array_push(get_leader().interactable_instances, o)
                    
                    cutscene_set_variable(o, "interaction_code", function(text) {
                        dialogue_start(text)
                    })
                    cutscene_set_variable(o, "interaction_args", [string(struct_get(dialogue, global.party_names[i]), party_getname(global.party_names[0]))])
                }
                
                array_push(members, global.party_names[i])
            }
        }
        
        cutscene_sleep(10)
        cutscene_set_variable(get_leader(), "dir", DIR.DOWN)
    }
    else {
        var _txt = []
        if array_contains(members, "susie") {
            array_push(_txt, "{char(susie, 9)}* Right behind you.")
        }
        if array_contains(members, "ralsei") {
            array_push(_txt, "{char(ralsei, 19)}* Catching up!")
        }
        if array_contains(members, "noelle") {
            array_push(_txt, "{char(noelle, 4)}* Coming!!")
        }
        
        if array_length(_txt) > 0 
            cutscene_dialogue(array_shuffle(_txt)[0])
        
        for (var i = 0; i < array_length(members); i ++) {
            var o = party_get_inst(members[i])
            if instance_exists(o) {
                o.collide = false
                if array_contains(get_leader().interactable_instances)
                    array_delete(get_leader().interactable_instances, 
                        array_get_index(get_leader().interactable_instances, o), 1
                    )
            }
        }
        
        cutscene_party_follow(true)
        
        members = []
        
        cutscene_sleep(10)
        cutscene_set_variable(get_leader(), "dir", DIR.DOWN)
    }
    
	cutscene_party_interpolate()
    cutscene_player_canmove(true)
	cutscene_play()
}