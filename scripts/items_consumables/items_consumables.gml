function item_lightcandy() : item() constructor {
	name = ["LightCandy"]
	desc = ["White candy with a chalky texture.\nIt'll recover 120HP.", "Heals 120HP"]
	
	use = function(index, target, caller = -1) {
		party_heal(target, 120, caller)
		item_delete(index)
	}
	reactions = {
		susie: "Hey, this rules!",
		ralsei: "Nice and chalky.",
		noelle: "(I-isn't this the chalk I gave her?)",
	}
    
    item_localize("item_c_lightcandy")
}
function item_darker_candy() : item() constructor {
	name = ["Darker Candy"]
	desc = ["A candy that has grown sweeter with time.\nSaid to taste like toasted marshmallow. +120HP", "Heals 120HP"]
	
	use = function(index, target, caller = -1) {
		party_heal(target, 40, caller)
		item_delete(index)
	}
	reactions = {
		susie: "Yeahh!! That's good!",
		ralsei: {
			susie: "Hey, feed ME!!!",
			ralsei: "Yummy!!! Marshmallows!!"
		},
		noelle: "Oh, it's... sticky?"
	}
    
    item_localize("item_c_darker_candy")
}
function item_top_cake() : item() constructor {
	name = ["Top Cake"]
	desc = ["This cake will make your taste buds spin! Heals 160HP to the team", "Heals team 160HP"]
	
	use_type = ITEM_USE.EVERYONE
	use = function(index, target, caller = -1) {
		party_heal_all(160, caller)
		item_delete(index)
	}
	
	reactions = {
		susie: "Mmm, seconds!",
		ralsei: "Whoops.",
		noelle: "Happy birthday! Haha!"
	}
    
    item_localize("item_c_top_cake")
}

function item_revivemint() : item() constructor {
	name = ["ReviveMint"]
	desc = ["Heals a fallen ally to MAX HP.\nA minty green crystal.", "Heals Downed Ally"]
	
	reactions = {
		susie: {
			susie: "I'm ALIVE!!!",
			ralsei: "(You weren't dead)",
		},
		ralsei: {
			susie: "(Don't look it)",
			ralsei: "Ah, I'm refreshed!",
		},
		noelle: "Mints? I love mints!",
	}
	use = function(index, target, caller) {
		if party_getdata(target, "hp") > 0{
			var heal = party_getdata(target, "max_hp") / 2
			party_heal(target, heal, caller)
		}
		else {
			var heal = max(party_getdata(target, "max_hp") - party_getdata(target, "hp"), 0)
			party_heal(target, heal, caller)
		}
		item_delete(index)
	}
    
    item_localize("item_c_revivemint")
}

function item_lw_shit() : item() constructor {
	name = ["Actual Shit"]
	desc = ["* Nobody knows what it actually does...", "HOW"]
	
	use = function(index, target, caller) {
		dialogue_start("* You smell the shit...{br}{resetx}{s(10)}* Ew. Why did you do that.")
	}
	throw_scripts = {
		can: true,
		execute_code: function(index){
			dialogue_start("* You dropped the shit. Now the room stinks. Thanks.")
			item_delete(index, 6)
		}
	}
}