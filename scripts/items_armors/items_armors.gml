function item_a_base() : item_base() constructor {
	type = ITEM_TYPE.ARMOR
	icon = spr_ui_menu_icon_armor
}

function item_a_silvercard() : item_a_base() constructor {
	name = ["Silver Card"]
	desc = ["A square charm that increases\ndropped money by 5%", "--"]
	
	stats = {
		defense: 4
	}
	affect = ["$ +5%", spr_ui_menu_icon_up]
	
	reactions = {
		susie: "Money, that's what I need.",
		ralsei: "Do they take credit?",
	}
}
function item_a_elementtest() : item_a_base() constructor {
	name = ["Element Charm"]
	desc = ["A peculiar object. Shines brightly. Protects from PUPPET/CAT elemental attacks.", "--"]
	
	stats = {
		defense: 3,
		element_resistance: {
			puppet_cat: 20,
		},
	}
	affect = ["P/C -20%", spr_ui_menu_icon_up]
	icon = spr_ui_menu_icon_armor
	
	reactions = {
		susie: "This smells like cat food.",
		ralsei: "Shiny!!",
		noelle: "Yuck. it's smelly...",
	}
}
function item_a_pink_ribbon() : item_a_base() constructor {
	name = ["Pink Ribbon"]
	desc = ["A cute hair ribbon. Increases the range at which bullets raise tension.", "--"]
	
	armor_blacklist = ["susie"]
	
	stats = {
		defense: 1,
	}
	affect = ["GrazeArea", spr_ui_menu_icon_up]
	
	reactions = {
		susie: "Nope. Not in 1st grade anymore.",
		ralsei: "Um... D-do I look cute...?",
		noelle: "... feels familiar.",
	}
}
function item_a_white_ribbon() : item_a_base() constructor {
	name = ["White Ribbon"]
	desc = ["A crinkly hair ribbon that slightly\nincreases your defense.", "--"]
	
	armor_blacklist = ["susie"]
	
	stats = {
		defense: 2,
	}
	affect = ["Cuteness", spr_ui_menu_icon_up]
	
	reactions = {
		susie: "Nope. Not in 1st grade anymore.",
		ralsei: "Um... D-do I look cute...?",
		noelle: "... feels familiar.",
	}
}
function item_a_twin_ribbon() : item_a_base() constructor {
	name = ["Twin Ribbon"]
	desc = ["Two ribbons. You'll have to put\nyour hair into pigtails.", "--"]
	
	armor_blacklist = ["susie"]
	
	stats = {
		defense: 3,
	}
	affect = ["GrazeArea", spr_ui_menu_icon_up]
	
	reactions = {
		susie: "... it gets worse and worse.",
		ralsei: "Try around my horns!",
		noelle: "... nostalgic, huh.",
	}
}