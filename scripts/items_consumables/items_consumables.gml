function item_consumable() : item() constructor {
	type = ITEM_TYPE.CONSUMABLE;
}

function item_lightcandy() : item_consumable() constructor {
	name = ["LightCandy"]
	desc = ["White candy with a chalky texture.\nIt'll recover 120HP.", "Heals 120HP"]
	
	use = function(item_index, target_index, caller = -1) {
		party_heal(global.party_names[target_index], 120, caller)
		item_delete(item_index)
	}
	reactions = {
		susie: "Hey, this rules!",
		ralsei: "Nice and chalky.",
		noelle: "(I-isn't this the chalk I gave her?)",
	}
    
    sell_price = 100
    
    item_localize("item_c_lightcandy")
}
item_register(item_lightcandy);

function item_darker_candy() : item_consumable() constructor {
	name = ["Darker Candy"]
	desc = ["A candy that has grown sweeter with time.\nSaid to taste like toasted marshmallow. +120HP", "Heals 120HP"]
	
    lw_counterpart = item_lw_shit
    
	use = function(item_index, target_index, caller = -1) {
		party_heal(global.party_names[target_index], 40, caller)
		item_delete(item_index)
	}
	reactions = {
		susie: "Yeahh!! That's good!",
		ralsei: {
			susie: "Hey, feed ME!!!",
			ralsei: "Yummy!!! Marshmallows!!"
		},
		noelle: "Oh, it's... sticky?"
	}
    
    buy_price = 240
    sell_price = 60
    
    item_localize("item_c_darker_candy")
}
item_register(item_darker_candy);

function item_top_cake() : item_consumable() constructor {
	name = ["Top Cake"]
	desc = ["This cake will make your taste buds spin! Heals 160HP to the team", "Heals team 160HP"]
	
	use_type = ITEM_USE.EVERYONE
	use = function(item_index, target_index, caller = -1) {
		party_heal_all(160, caller)
		item_delete(item_index)
	}
	
	reactions = {
		susie: "Mmm, seconds!",
		ralsei: "Whoops.",
		noelle: "Happy birthday! Haha!"
	}
    
    sell_price = 75
    
    item_localize("item_c_top_cake")
}
item_register(item_top_cake);

function item_revivemint() : item_consumable() constructor {
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
	use = function(item_index, target_index, caller) {
        var target = global.party_names[target_index]
        
		if party_getdata(target, "hp") > 0{
			var heal = party_getdata(target, "max_hp") / 2
			party_heal(target, heal, caller)
		}
		else {
			var heal = max(party_getdata(target, "max_hp") - party_getdata(target, "hp"), 0)
			party_heal(target, heal, caller)
		}
		item_delete(item_index)
	}
    
    sell_price = 200
    
    item_localize("item_c_revivemint")
}
item_register(item_revivemint);