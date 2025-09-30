function item_weapon() : item() constructor {
	type = ITEM_TYPE.WEAPON
}

// swords
function item_w_spookysword() : item_weapon() constructor {
	name = ["Spookysword"]
	desc = ["A black-and-orange sword with a bat hilt.", "--"]
	lw_counterpart = item_w_lw_halloweenpencil
    
	stats = {
		attack: 2, 
	}
	effect = {
        text: "Spookiness UP",
        sprite: spr_ui_menu_icon_up
    }
	icon = spr_ui_menu_icon_sword
	
	weapon_whitelist = ["kris"]
	weapon_fatal = true
	
	reactions = {
		susie: "Ugh, it's too small!",
		ralsei: "Oh, it's too scary!",
        noelle: "(It's kinda cool...)"
	}
}
function item_w_lw_halloweenpencil() : item_weapon() constructor {
    name = ["Halloween Pencil"]
	desc = ["* Orange with black bats on it.", "--"]
	
	stats = {
        attack: 1,
    }
}

function item_w_woodblade() : item_weapon() constructor {
	name = ["Wood Blade"]
	desc = ["A wooden practice blade with a carbon-\nreinforced core.", "--"]
    lw_counterpart = item_w_lw_pencil
	
	stats = {}
	icon = spr_ui_menu_icon_sword
	weapon_whitelist = ["kris"]
	
	reactions = {
		susie: "What's this!? A CHOPSTICK?",
		ralsei: "That's yours, Kris...",
        noelle: "(It has bite marks...)"
	}
}
function item_w_lw_pencil() : item_weapon() constructor {
    name = ["Pencil"]
	desc = ["* Mightier than a sword? Maybe equal at best.", "--"]
	
	stats = {
        attack: 1,
    }
}

function item_w_saber10() : item_weapon() constructor {
	name = ["Saber10"]
	desc = ["A saber made of 10 cactus needles. Fortunately, can deal more than 10 damage.", "--", "Tsun-type armaments"]
	lw_counterpart = item_w_lw_cactusneedle
    
	stats = {
        attack: 6,
    }
	icon = spr_ui_menu_icon_sword
	weapon_whitelist = ["kris"]
	
	reactions = {
		susie: "Nah, I'd snap it.",
		ralsei: "You want to... pierce my ears...?",
		noelle: "(I'm not against using it, but...)",
	}
}
function item_w_lw_cactusneedle() : item_weapon() constructor {
	name = ["CactusNeedle"]
	desc = ["* Ouch! ... It's somewhat sentimental in a way.", "--"]
	
	stats = {
        attack: 2,
    }
}

function item_w_jingleblade() : item_weapon() constructor {
	name = ["Jingle Blade"]
	desc = ["A lance-like sword with red-and-white stripes. Perfect for jousting.", "--"]
	lw_counterpart = item_w_lw_holidaypencil
    
	stats = {
        attack: 7,
        defense: 1,
    }
	icon = spr_ui_menu_icon_sword
	weapon_whitelist = ["kris", "noelle"]
    effect = {
        text: "Festive",
        sprite: spr_ui_menu_icon_smile
    }
	
	reactions = {
		susie: "Sleigh the bad guys.",
		ralsei: "Mmm! Minty and festive!",
		noelle: "What is this, a barber pole?",
	}
}
function item_w_lw_holidaypencil() : item_weapon() constructor {
	name = ["Holiday Pencil"]
	desc = ["* A festive candycane pencil. Do not eat.", "--"]
	
	stats = {
        attack: 1,
    }
}

// axes
function item_w_maneax() : item_weapon() constructor {
    name = ["Mane Ax"]
	desc = ["Beginner's ax forged from the mane of a dragon whelp.", "--"]
	
	stats = {} 
	icon = spr_ui_menu_icon_axe
	weapon_whitelist = []
	
	reactions = {
		susie: "I'm too GOOD for that.",
		ralsei: "Ummm... it's a bit big.",
		noelle: "It... smells nice...",
	}
}
function item_w_devilsknife() : item_weapon() constructor {
	name = ["Devilsknife"]
	desc = ["Skull-emblazoned scythe-ax.\nReduces Rudebuster's cost by 10"]
	
	stats = {
        attack: 5,
        magic: 4,
    } 
    effect = {
        text: "Buster TP DOWN",
        sprite: spr_ui_menu_icon_down
    }
	icon = spr_ui_menu_icon_axe
	weapon_whitelist = ["susie"]
	
	reactions = {
		susie: "Let the games begin!",
		ralsei: "It's too, um, evil.",
		noelle: "...? It smiled at me?",
	}
}    
function item_w_absorbax() : item_weapon() constructor {
	name = ["AbsorbAx"]
	desc = ["A long, curved axe with an indent. Scoop up HP when you attack."]
	
	stats = {
        attack: 8,
    } 
	icon = spr_ui_menu_icon_axe
	weapon_whitelist = ["susie"]
	
	reactions = {
		susie: "Scoopin' time.",
		ralsei: "Don't scoop me!",
		noelle: "That red... is that blood?",
	}
}  

// scarfs
function item_w_redscarf() : item_weapon() constructor {
	name = ["Red Scarf"]
	desc = ["A basic scarf made of lightly\nmagical fiber.", "--"]
	
	stats = {} // it does nothing (cries and runs off)
	icon = spr_ui_menu_icon_scarf
	weapon_whitelist = ["ralsei"]
	
	reactions = {
		susie: "No. Just... no.",
		ralsei: "Comfy! Touch it, Kris!",
		noelle: "Huh? No, I'm not cold.",
	}
}
function item_w_flexscarf() : item_weapon() constructor {
	name = ["Flex Scarf"]
	desc = ["A scarf that is warm and fuzzy, but with a metal core that lets it keep its shape.", "--", "Weaklings can flex too"]
	
	stats = {
        attack: 4,
        magic: 1,
    } 
	icon = spr_ui_menu_icon_scarf
	weapon_whitelist = ["ralsei"]
	
	reactions = {
		susie: "Looks like a giant caterpillar.",
		ralsei: "So pliable, like me!",
		noelle: "Twist it and... it's a wreath!",
	}
}
function item_w_puppetscarf() : item_weapon() constructor {
	name = ["PuppetScarf"]
	desc = ["A scarf made of strange strings. For those that abandon healing."]
	
	stats = {
        attack: 10,
        magic: -6,
    } 
	icon = spr_ui_menu_icon_scarf
	weapon_whitelist = ["ralsei"]
	
	reactions = {
		susie: "No way, that's creepy.",
		ralsei: "If I have to fight...",
		noelle: "(Feels like guitar strings...)",
	}
} 

// rings
function item_w_snowring() : item_weapon() constructor {
	name = ["SnowRing"]
	desc = ["A ring with the emblem of the snowflake"]
	
	stats = {}
	icon = spr_ui_menu_icon_ring
	weapon_whitelist = ["noelle"]
	
	reactions = {
		susie: "Smells like Noelle",
		ralsei: "Are you... proposing?",
		noelle: "(Thank goodness...)",
	}
}
function item_w_freezering() : item_weapon() constructor {
	name = ["FreezeRing"]
	desc = ["A ring with a snowglobe on it. ... is that someone inside?"]
	
	stats = {
        attack: 4,
        magic: 4,
    } 
	icon = spr_ui_menu_icon_ring
	weapon_whitelist = ["noelle"]
	
	reactions = {
		susie: "Heh, you steal this? Heh.",
		ralsei: "It's beautiful...",
		noelle: "...",
	}
}  