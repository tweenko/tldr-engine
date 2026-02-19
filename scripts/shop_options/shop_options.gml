enum SHOP_TALK_CONTEXT {
    IDLE,
    
    BOUGHT,
    BOUGHT_STORAGE,
    
    CANCELED,
    
    NOT_ENOUGH,
    NO_SPACE,
}

function shop_option() constructor {
    name = "Option"
    color = c_white
    enabled = true
    
    use = function() {}
    
    step = function() {}
    drawer = function() {}
}

function shop_option_buy(_items, _talk_gen) : shop_option() constructor {
    name = "Buy"
    items = _items
    
    talk_context = SHOP_TALK_CONTEXT.IDLE
    talk_gen = _talk_gen
    
    use = method(self, function() {
        box_h = 40
    })
    cancel = method(self, function() {
        other.menu_in_options = true
        talk_context = SHOP_TALK_CONTEXT.IDLE
    })
    
    box_h = 40
    buy_prompt = false
    buy_prompt_selection = 0
    selection = 0
    
    step = method(self, function() {
        #region replicate deltarune's box height calculation
        var box_y = 240 - box_h
        if selection < array_length(items) {
            if box_y <= 20
                box_y = 20
            if box_y > 20
                box_y -= 5
            if box_y > 50
                box_y -= 5
            if box_y > 100
                box_y -= 8;
            if box_y > 150
                box_y -= 10;
        }
        else if box_y < 200
            box_y += 40
        
        box_y = clamp(box_y, 20, 200)
        box_h = (240 - box_y)
        #endregion
        
        if !instance_exists(other.inst_small_talk) && !buy_prompt
            other.inst_small_talk = text_typer_create(talk_gen(talk_context), 
                450, 260, DEPTH_UI.MENU_UI, 
                other.shop_data.flavor_prefix, "", {
                    gui: true,
                    can_superskip: false,
                    max_width: 176,
                    break_tabulation: false
                }
            )
        
        if buy_prompt {
            if InputPressed(INPUT_VERB.DOWN)
                buy_prompt_selection ++
            else if InputPressed(INPUT_VERB.UP)
                buy_prompt_selection --
            buy_prompt_selection = cap_wraparound(buy_prompt_selection, 2)
            
            if InputPressed(INPUT_VERB.SELECT) && buy_prompt_selection == 0 {
                var item_type = item_get_type(items[selection])
                if save_get("money") > item_get_shop_cost(items[selection]) {
                    buy_prompt = false
                    talk_context = SHOP_TALK_CONTEXT.NOT_ENOUGH
                }
                else if array_length(item_get_array(item_type)) > item_get_maxcount(item_type) && item_type != ITEM_TYPE.CONSUMABLE  {
                    buy_prompt = false
                    talk_context = SHOP_TALK_CONTEXT.NO_SPACE
                }
                else {
                    buy_prompt = false
                    talk_context = SHOP_TALK_CONTEXT.BOUGHT
                    
                    var __sc = asset_get_index(instanceof(items[selection]))
                    if item_type == ITEM_TYPE.CONSUMABLE {
                		if item_get_count(item_type) + 1 > item_get_maxcount(item_type)  {
                			if item_get_count(ITEM_TYPE.STORAGE) + 1 <= item_get_maxcount(ITEM_TYPE.STORAGE) {
                                item_add(new __sc(), ITEM_TYPE.CONSUMABLE)
                            audio_play(snd_locker)
                				talk_context = SHOP_TALK_CONTEXT.BOUGHT_STORAGE
                            }
                            else 
                				talk_context = SHOP_TALK_CONTEXT.NO_SPACE
                		}
                        else {
                            item_add(new __sc(), ITEM_TYPE.CONSUMABLE)
                            audio_play(snd_locker)
                        }
                	}
                    else {
                        if item_get_count(item_type) + 1 > item_get_maxcount(item_type) 
                            talk_context = SHOP_TALK_CONTEXT.NO_SPACE
                        else 
                            audio_play(snd_locker)
                        item_add(new __sc())
                    }
                }
            }
            if InputPressed(INPUT_VERB.SELECT) && buy_prompt_selection == 1
                ||  InputPressed(INPUT_VERB.CANCEL)
            {
                buy_prompt_selection = 0
                buy_prompt = false
                talk_context = SHOP_TALK_CONTEXT.CANCELED
            }
        }
        else {
            if InputPressed(INPUT_VERB.DOWN)
                selection ++
            else if InputPressed(INPUT_VERB.UP)
                selection --
            
            if InputPressed(INPUT_VERB.SELECT) {
                if selection == array_length(items)
                    cancel()
                else 
                    buy_prompt = true
                instance_destroy(other.inst_small_talk)
            }
            
            if InputPressed(INPUT_VERB.CANCEL)
                cancel()
            
            selection = cap_wraparound(selection, array_length(items) + 1)
        }
    })
    
    surf_item_info = -1
    drawer = method(self, function() {
        var _selection = selection
        
        var item_type = ITEM_TYPE.CONSUMABLE
        var space = 0
        var array = []
        
        // if the item is valid, assign type, space and array
        if _selection < array_length(items) {
            item_type = item_get_type(items[_selection])
            space = item_get_maxcount(item_type) 
            array = item_get_array(item_type)
            
            if item_type == ITEM_TYPE.CONSUMABLE
                if item_get_count(ITEM_TYPE.CONSUMABLE) >= item_get_maxcount(ITEM_TYPE.CONSUMABLE) {
                    space = item_get_maxcount(ITEM_TYPE.STORAGE)
                    array = array_filter(item_get_array(ITEM_TYPE.STORAGE), function(i) {
                        return !is_undefined(i)
                    })
                }
        }
        
        draw_set_font(loc_font("main"))
        for (var i = 0; i < array_length(items); i ++) {
            draw_text_transformed(60, 260 + 40*i, item_get_name(items[i]), 2, 2, 0)
            draw_text_xfit(300, 260 + 40*i, $"${item_get_shop_cost(items[i])}", 170, 2, 2)
            
            if _selection == i && !buy_prompt
                draw_sprite_ext(spr_uisoul, 0, 30, 270 + 40*i, 1, 1, 0, c_red, 1)
        }
        
        // exit
        if _selection == array_length(items) && !buy_prompt
            draw_sprite_ext(spr_uisoul, 0, 30, 430, 1, 1, 0, c_red, 1)
        draw_text_transformed(60, 420, "Exit", 2, 2, 0)
        
        draw_set_font(loc_font("enc"))
        if !is_undefined(space) && !is_undefined(array) && _selection < array_length(items)
            draw_text(520, 430, $"Space: {space - array_length(array)}")
        
        var __display_h = round_p(box_h, 2)
        ui_dialoguebox_create(408, 248 - __display_h, 225, __display_h)
        
        if !surface_exists(surf_item_info)
            surf_item_info = surface_create(640, 480)
        
        surface_set_target(surf_item_info)
        draw_clear_alpha(0, 0)
        draw_set_font(loc_font("main"))
        
        if _selection < array_length(items) && !is_undefined(items[_selection]) {
            draw_text_ext_transformed(440, 240 - __display_h + 28, 
                $"{string_upper(item_get_type_name(item_type))}\n{item_get_desc(items[_selection], ITEM_DESC_TYPE.SHOP)}", 
                16, 88, 2, 2, 0
            )
            
            if item_type == ITEM_TYPE.WEAPON || item_type == ITEM_TYPE.ARMOR {
                var __get_diff_color = function(diff) {
                    switch sign(diff) {
                        default:
                            return c_white
                        case 1:
                            return c_yellow
                        case -1:
                            return c_aqua
                    }
                }
                
                draw_set_font(loc_font("enc"))
                for (var i = 0; i < array_length(global.party_names); i ++) {
                    var x_off = (i % 2) * 100
                    var y_off = (i div 2) * 45 + 220 - box_h
                    draw_sprite_ext(party_geticon(global.party_names[i]), 0, 425 + x_off, 160 + y_off, 1, 1, 0, c_white, 1)
                    
                    if item_type == ITEM_TYPE.WEAPON {
                        var og_attack = item_get_stat(party_getdata(global.party_names[i], "weapon"), "attack")
                        var attack_diff = item_get_stat(items[_selection], "attack") - og_attack
                        var og_magic = item_get_stat(party_getdata(global.party_names[i], "weapon"), "magic")
                        var magic_diff = item_get_stat(items[_selection], "magic") - og_magic
                        
                        draw_sprite_ext(spr_ui_shop_weapon, 0, 470 + x_off, 155 + y_off, 1, 1, 0, c_white, 1)
                        draw_sprite_ext(spr_ui_shop_magic, 0, 470 + x_off, 175 + y_off, 1, 1, 0, c_white, 1)
                        
                        draw_set_colour(__get_diff_color(attack_diff))
                        
                        if sign(attack_diff) == 1 
                            attack_diff = $"+{attack_diff}"
                        draw_text(490 + x_off, 156 + y_off, attack_diff)
                        
                        draw_set_colour(__get_diff_color(magic_diff))
                        
                        if sign(magic_diff) == 1 
                            magic_diff = $"+{magic_diff}"
                        draw_text(490 + x_off, 176 + y_off, magic_diff)
                        
                        draw_set_colour(c_white)
                    }
                    else if item_type == ITEM_TYPE.ARMOR {
                        var a1_og_defense = item_get_stat(party_getdata(global.party_names[i], "armor1"), "defense")
                        var a1_diff = item_get_stat(items[_selection], "defense") - a1_og_defense
                        var a2_og_defense = item_get_stat(party_getdata(global.party_names[i], "armor2"), "defense")
                        var a2_diff = item_get_stat(items[_selection], "defense") - a2_og_defense
                        
                        draw_sprite_ext(spr_ui_menu_armor1, 0, 470 + x_off, 155 + y_off, 1, 1, 0, c_white, 1)
                        draw_sprite_ext(spr_ui_menu_armor2, 0, 470 + x_off, 175 + y_off, 1, 1, 0, c_white, 1)
                        
                        draw_set_colour(__get_diff_color(a1_diff))
                        
                        if sign(a1_diff) == 1 
                            a1_diff = $"+{a1_diff}"
                        draw_text(490 + x_off, 156 + y_off, a1_diff)
                        
                        draw_set_colour(__get_diff_color(a2_diff))
                        
                        if sign(a2_diff) == 1 
                            a2_diff = $"+{a2_diff}"
                        draw_text(490 + x_off, 176 + y_off, a2_diff)
                        
                        draw_set_colour(c_white)
                    }
                }
            }
        }
        
        gpu_set_blendmode(bm_subtract)
        draw_rectangle(0, 244, 640, 480, false)
        gpu_set_blendmode(bm_normal)
        
        surface_reset_target()
        draw_surface(surf_item_info, 0, 0)
        
        if buy_prompt {
            draw_set_font(loc_font("main"))
            
            draw_text_ext_transformed(460, 260, $"Buy it for {item_get_shop_cost(items[_selection])}?", 16, 70, 2, 2, 0)
            
            draw_sprite_ext(spr_uisoul, 0, 450, 350 + buy_prompt_selection*30, 1, 1, 0, c_red, 1)
            
            draw_text_transformed(480, 340, "Yes", 2, 2, 0)
            draw_text_transformed(480, 370, "No", 2, 2, 0)
        }
    })
}
function shop_option_sell() : shop_option() constructor {
    name = "Sell"
}
function shop_option_talk() : shop_option() constructor {
    name = "Talk"
}
function shop_option_exit() : shop_option() constructor {
    name = "Exit"
}