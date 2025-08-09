function item_w_base() : item_base() constructor {
	type = ITEM_TYPE.WEAPON
}

function item_w_spookysword() : item_w_base() constructor {
	name = ["Spookysword"]
	desc = ["A black-and-orange sword with a bat hilt.", "--"]
	
	stats = {
		attack: 2, 
		magic: 1
	}
	affect = ["Spookiness UP", spr_ui_menu_icon_up]
	icon = spr_ui_menu_icon_sword
	
	weapon_whitelist = ["kris"]
	weapon_fatal = true
	
	reactions = {
		susie: "Ugh, it's too small!",
		ralsei: "Oh, it's too scary!",
	}
}
function item_w_woodblade() : item_w_base() constructor {
	name = ["Wood Blade"]
	desc = ["A wooden practice blade with a carbon-\nreinforced core.", "--"]
	
	stats = {}
	icon = spr_ui_menu_icon_sword
	weapon_whitelist = ["kris"]
	
	reactions = {
		susie: "What's this!? A CHOPSTICK?",
		ralsei: "That's yours, Kris...",
	}
}