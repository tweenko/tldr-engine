function item_armor() : item() constructor {
	type = ITEM_TYPE.ARMOR
	icon = spr_ui_menu_icon_armor
}

function item_a_ambercard() : item_armor() constructor {
    name = ["Amber Card"]
	desc = ["A thin square charm that sticks to you, increasing defense.", "--", "Defensive charm"]
	
	stats = {
		defense: 1
	}
	
	reactions = {
		susie: "... better than nothing.",
		ralsei: "It's sticky, huh, Kris...",
		noelle: "It's like a name-tag!",
	}
    
    item_localize("item_a_amber_card")
}
function item_a_silvercard() : item_armor() constructor {
	name = ["Silver Card"]
	desc = ["A square charm that increases\ndropped money by 5%", "--"]
	
	stats = {
		defense: 4
	}
	effect = {
        text: "$ +5%",
        sprite: spr_ui_menu_icon_up
    }
    
    stats_misc = {
        money_modifier: .05
    }
	
	reactions = {
		susie: "Money, that's what I need.",
		ralsei: "Do they take credit?",
		noelle: "It goes with my watch!",
	}
    
    item_localize("item_a_silver_card")
}

function item_a_pink_ribbon() : item_armor() constructor {
	name = ["Pink Ribbon"]
	desc = ["A cute hair ribbon. Increases the range at which bullets raise tension.", "--"]
	
	armor_blacklist = ["susie"]
	
	stats = {
		defense: 1,
	}
	effect = {
        text: "GrazeArea",
        sprite: spr_ui_menu_icon_up
    }
	
	reactions = {
		susie: "Nope. Not in 1st grade anymore.",
		ralsei: "Um... D-do I look cute...?",
		noelle: "... feels familiar.",
	}
    
    item_localize("item_a_pink_ribbon")
}
function item_a_white_ribbon() : item_armor() constructor {
	name = ["White Ribbon"]
	desc = ["A crinkly hair ribbon that slightly\nincreases your defense.", "--"]
	
	armor_blacklist = ["susie"]
	
	stats = {
		defense: 2,
	}
	effect = {
        text: "Cuteness",
        sprite: spr_ui_menu_icon_up
    }
	
	reactions = {
		susie: "Nope. Not in 1st grade anymore.",
		ralsei: "Um... D-do I look cute...?",
		noelle: "... feels familiar.",
	}
    
    item_localize("item_a_white_ribbon")
}
function item_a_twin_ribbon() : item_armor() constructor {
	name = ["Twin Ribbon"]
	desc = ["Two ribbons. You'll have to put\nyour hair into pigtails.", "--"]
	
	armor_blacklist = ["susie"]
	
	stats = {
		defense: 3,
	}
	effect = {
        text: "GrazeArea",
        sprite: spr_ui_menu_icon_up
    }
	
	reactions = {
		susie: "... it gets worse and worse.",
		ralsei: "Try around my horns!",
		noelle: "... nostalgic, huh.",
	}
    
    item_localize("item_a_twin_ribbon")
}

function item_a_royal_pin() : item_armor() constructor {
    name = ["Royal Pin"]
    desc = ["A brooch engraved with Queen's face. Careful of the sharp point.", "--", "Luxurious brooch."]
    
	stats = {
		defense: 3,
        magic: 1
	}
	
	reactions = {
		susie: "ROACH? Oh, brooch. Heh.",
		ralsei: "I'm a cute little corkboard!",
		noelle: "Queen... gave this to me.",
	}
    
    item_localize("item_a_royal_pin")
}
function item_a_silver_watch() : item_armor() constructor {
    name = ["Silver Watch"]
    desc = ["Grazing bullets affects the turn length by 10% more", "--"]
	lw_counterpart = item_a_lw_wristwatch
    
	stats = {
		defense: 2,
	}
	effect = {
        text: "GrazeTime",
        sprite: spr_ui_menu_icon_up
    }
	
	reactions = {
		susie: "It's clobbering time.",
		ralsei: "I'm late, I'm late!",
		noelle: "(Th-this was mine...)",
	}
    
    item_localize("item_a_silver_watch")
}
function item_a_lw_wristwatch() : item_armor() constructor {
    name = ["Wristwatch"]
    desc = ["* Maybe an expensive antique. Stuck before half past noon.", "--"]
	
	stats = {
		defense: 1,
	}
    
    item_localize("item_a_wristwatch")
}

function item_a_dealmaker() : item_armor() constructor {
    name = ["Dealmaker"]
    desc = ["Fashionable pink and yellow glasses.\nGreatly increases $ gained, and...?", "--"]
    
	stats = {
		defense: 5,
        magic: 5,
        element_resistance: {
			puppet_cat: .4,
		},
	}
    stats_misc = {
        money_modifier: .3
    }
	effect = {
        text: "$ +30%",
        sprite: spr_ui_menu_icon_up
    }
	
	reactions = {
		susie: "Money, that's what I need.",
		ralsei: "Two pairs of glasses?",
		noelle: "(Seems... familiar?)",
	}
    
    item_localize("item_a_dealmaker")
}
function item_a_shadowmantle() : item_armor() constructor {
    name = ["ShadowMantle"]
    desc = ["Shadows slip off like water.\nGreatly protects against Dark and Star attacks.", "--"]
    
    armor_blacklist = ["noelle"]
    
	stats = {
		defense: 3,
        element_resistance: {
			dark_star: .66,
		},
	}
	effect = {
        text: "Dark/Star",
        sprite: spr_ui_menu_icon_armor
    }
	
	reactions = {
		susie: "Hell yeah, what's this?",
		ralsei: "Sh-should I wear this...?",
		noelle: "No... it's for someone... taller.",
	}
    
    item_localize("item_a_shadowmantle")
}