function ex_item_butjuice() : item() constructor {
    name = ["ButJuice"]
	desc = [
        "It's short for ButlerJuice.\nIt changes color with temperature.", 
        "Heals\n 100HP",
        "",
        "Short for ButlerJuice\n+100HP"
    ]
	
	use = function(item_index, target_index, caller = -1) {
		party_heal(global.party_names[target_index], 100, caller)
		item_delete(item_index)
	}
	reactions = {
		susie: "Hell'd you call this!?",
		ralsei: "I made this.",
		noelle: "B-Brainfreeze! ... kidding!",
	}
    
    shop_cost = 200
}

function ex_item_spagetticode() : item() constructor {
    name = ["SpagettiCode"]
	desc = [
        "Spaghetti woven by master coders, made\nof macarons and ribbons. +30HP to all.", 
        "Heals\nteamn\n30HP",
        "",
        "Spaghetti woven by master coders\nParty +30HP"
    ]
	
	use = function(item_index, target_index, caller = -1) {
		party_heal_all(30, caller)
		item_delete(item_index)
	}
	reactions = {
		susie: "I'm NOT wearing it.",
		ralsei: "How sweet!",
		noelle: "Reminds me of one of my sweaters.",
	}
    
    shop_cost = 180
}

function ex_item_a_bshotbowtie() : item_armor() constructor {
    name = ["B.ShotBowtie"]
	desc = [
        "A handsome bowtie. Looks like the brand\nname has been cut off.", 
        "",
        "",
        "A handsome bowtie."
    ]
	
	stats = {
        magic: 1,
        defense: 2,
    }
	reactions = {
		susie: "Ugh, I look like a nerd.",
		ralsei: "Can I have suspenders?",
		noelle: "... do I put it in my hair?",
	}
    
    shop_cost = 300
}

function ex_item_a_royalpin() : item_armor() constructor {
    name = ["RoyalPin"]
	desc = [
        "A brooch engraved with Queen's face.\nCareful of the sharp part.", 
        "",
        "",
        "Luxurious brooch."
    ]
	
	stats = {
        magic: 1,
        defense: 3,
    }
	reactions = {
		susie: "ROACH? Oh, brooch. Heh.",
		ralsei: "I'm a cute little corkboard!",
		noelle: "Queen... gave this to me.",
	}
    
    shop_cost = 1000
}
