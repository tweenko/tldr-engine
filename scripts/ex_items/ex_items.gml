function ex_item_butjuice() : item() constructor {
    name = "ButJuice"
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
    
    buy_price = 200
    
    item_localize("ex_item_butjuice")
}

function ex_item_spagetticode() : item() constructor {
    name = "SpagettiCode"
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
    
    buy_price = 180
    
    item_localize("ex_item_spagetticode")
}

function ex_item_a_bshotbowtie() : item_armor() constructor {
    name = "B.ShotBowtie"
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
    
    buy_price = 300
    
    item_localize("ex_item_a_bshotbowtie")
}

function ex_item_tesniongem() : item() constructor {
    name = "TensionGem"
    desc = [
        "Raises TP by 50% in battle.",
        "Raises\nTP\n50%"
    ]
    use_type = ITEM_USE.EVERYONE
    
    use_instant = function() {
        o_enc.tp += 50
    }
    use_instant_cancel = function() {
        o_enc.tp -= 50
    }
    use = function(item_index, target_index) {
        if !instance_exists(o_enc) {
            instance_destroy(o_ui_menu)
            dialogue_start(loc("ex_item_tensiongem_use"))
        }
        
        item_delete(item_index)
    }
    
    sell_price = 150
    
    item_localize("ex_item_tensiongem")
}