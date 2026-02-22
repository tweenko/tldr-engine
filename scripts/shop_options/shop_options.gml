enum SHOP_TALK_CONTEXT {
    IDLE,
    
    BOUGHT,
    BOUGHT_STORAGE,
    
    CANCELED,
    
    NOT_ENOUGH,
    NO_SPACE,
    
    NO_ITEMS,
    SOLD,
    SELL_CONSUMABLE,
    SELL_WEAPON,
    SELL_ARMOR,
    REFUSE
}

function shop_option() constructor {
    name = "Option"
    color = c_white
    enabled = true
    
    use = function() {}
    
    step = function() {}
    drawer = function() {}
}

/// @desc constructor for the shop option "buy"
/// @arg {array<struct.item>} _items the items the vendor sells
/// @arg {function} _talk_gen a function that returns a sidebar response. given context as argument 0 (see `SHOP_TALK_CONTEXT`)
function shop_option_buy(_items, _talk_gen) : shop_option() constructor {
    name = loc("shop_option_buy")
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
                    max_width: 160,
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
        var item_type = ITEM_TYPE.CONSUMABLE
        var space = 0
        var array = []
        
        // if the item is valid, assign type, space and array
        if selection < array_length(items) {
            item_type = item_get_type(items[selection])
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
            
            if selection == i && !buy_prompt
                draw_sprite_ext(spr_uisoul, 0, 30, 270 + 40*i, 1, 1, 0, c_red, 1)
        }
        
        // exit
        if selection == array_length(items) && !buy_prompt
            draw_sprite_ext(spr_uisoul, 0, 30, 430, 1, 1, 0, c_red, 1)
        draw_text_transformed(60, 420, loc("shop_option_exit"), 2, 2, 0)
        
        var __space = space - array_length(array)
        draw_set_font(loc_font("enc"))
        if !is_undefined(space) && !is_undefined(array) && selection < array_length(items)
            draw_text(520, 430, (__space > 0 
                ? string(loc("shop_buy_space"), __space) 
                : loc("shop_buy_no_space")
            ))
        
        var __display_h = round_p(box_h, 2)
        ui_dialoguebox_create(408, 248 - __display_h, 225, __display_h)
        
        if !surface_exists(surf_item_info)
            surf_item_info = surface_create(640, 480)
        
        surface_set_target(surf_item_info)
        draw_clear_alpha(0, 0)
        draw_set_font(loc_font("main"))
        
        if selection < array_length(items) && !is_undefined(items[selection]) {
            draw_text_ext_transformed(440, 240 - __display_h + 28, 
                $"{string_upper(item_get_type_name(item_type))}\n{item_get_desc(items[selection], ITEM_DESC_TYPE.SHOP)}", 
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
                        var attack_diff = item_get_stat(items[selection], "attack") - og_attack
                        var og_magic = item_get_stat(party_getdata(global.party_names[i], "weapon"), "magic")
                        var magic_diff = item_get_stat(items[selection], "magic") - og_magic
                        
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
                        var a1_diff = item_get_stat(items[selection], "defense") - a1_og_defense
                        var a2_og_defense = item_get_stat(party_getdata(global.party_names[i], "armor2"), "defense")
                        var a2_diff = item_get_stat(items[selection], "defense") - a2_og_defense
                        
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
            
            draw_text_ext_transformed(460, 260, string(loc("shop_buy_prompt"), item_get_shop_cost(items[selection])), 16, 70, 2, 2, 0)
            
            draw_sprite_ext(spr_uisoul, 0, 450, 350 + buy_prompt_selection*30, 1, 1, 0, c_red, 1)
            
            draw_text_transformed(480, 340, loc("shop_query_yes"), 2, 2, 0)
            draw_text_transformed(480, 370, loc("shop_query_no"), 2, 2, 0)
        }
    })
}

/// @desc constructor for the shop option "sell"
/// @arg {array<struct>} _sell_options an array of sell options. each struct inside should have a type, name and small_talk hashes
/// @arg {function} _talk_gen a function that returns a sidebar response. given context as argument 0 (see `SHOP_TALK_CONTEXT`)
/// @arg {array<function>} _refuse_items items that the vendor will refuse to buy. empty by default
function shop_option_sell(_sell_options = [
        {type: ITEM_TYPE.CONSUMABLE, name: loc("shop_sell_items"), small_talk: SHOP_TALK_CONTEXT.SELL_CONSUMABLE},
        {type: ITEM_TYPE.WEAPON, name: loc("shop_sell_weapons"), small_talk: SHOP_TALK_CONTEXT.SELL_WEAPON},
        {type: ITEM_TYPE.ARMOR, name: loc("shop_sell_armor"), small_talk: SHOP_TALK_CONTEXT.SELL_ARMOR},
        {type: ITEM_TYPE.STORAGE, name: loc("shop_sell_pocket_items"), small_talk: SHOP_TALK_CONTEXT.SELL_CONSUMABLE},
    ], _talk_gen = function(){}, _refuse_items = []
) : shop_option() constructor  {
    name = loc("shop_option_sell")
    
    sell_options = _sell_options
    refuse_items = _refuse_items
    talk_gen = _talk_gen
    talk_context = SHOP_TALK_CONTEXT.IDLE
    
    selection = 0
    item_selection = 0
    item_selection_off = 0
    sell_prompt_selection = 0
    
    choosing_item = false
    sell_prompt = false
    
    cancel = method(self, function() {
        other.menu_in_options = true
        talk_context = SHOP_TALK_CONTEXT.IDLE
    })
    
    step = method(self, function() {
        if !instance_exists(other.inst_small_talk) && !sell_prompt
            other.inst_small_talk = text_typer_create(talk_gen(talk_context), 
                450, 260, DEPTH_UI.MENU_UI, 
                other.shop_data.flavor_prefix, "", {
                    gui: true,
                    can_superskip: false,
                    max_width: (loc_getlang() == "ja" ? 164 : 176),
                    break_tabulation: false
                }
            )
        
        if !choosing_item {
            if InputPressed(INPUT_VERB.DOWN)
                selection ++
            else if InputPressed(INPUT_VERB.UP)
                selection --
            
            if InputPressed(INPUT_VERB.SELECT) {
                instance_destroy(other.inst_small_talk)
                
                if selection == array_length(sell_options)
                    cancel()
                else {
                    var item_type = sell_options[selection].type
                    if item_get_count(item_type) == 0 {
                        talk_context = SHOP_TALK_CONTEXT.NO_ITEMS
                        audio_play(snd_ui_cant_select)
                    }
                    else {
                        choosing_item = true
                        talk_context = sell_options[selection].small_talk
                    }
                }
            }
            
            if InputPressed(INPUT_VERB.CANCEL)
                cancel()
            
            selection = cap_wraparound(selection, array_length(sell_options) + 1)
        }
        else if sell_prompt {
            if InputPressed(INPUT_VERB.DOWN)
                sell_prompt_selection ++
            if InputPressed(INPUT_VERB.UP)
                sell_prompt_selection --
            sell_prompt_selection = cap_wraparound(sell_prompt_selection, 2)
            
            if InputPressed(INPUT_VERB.SELECT) && sell_prompt_selection == 1
                ||  InputPressed(INPUT_VERB.CANCEL)
            {
                sell_prompt_selection = 0
                sell_prompt = false
                talk_context = SHOP_TALK_CONTEXT.CANCELED
            }
            else if InputPressed(INPUT_VERB.SELECT) {
                var items_display = 5
                var item_type = sell_options[selection].type
                var item_array = item_get_array(item_type)
                
                audio_play(snd_locker)
                global.save.MONEY += item_get_shop_sell_price(item_array[item_selection])
                item_delete(item_selection, item_type)
                
                instance_destroy(other.inst_small_talk)
                talk_context = SHOP_TALK_CONTEXT.SOLD
                
                if item_selection > 0
                    item_selection --
                else if item_get_count(item_type) == 0
                    choosing_item = false
                
                while item_selection < item_selection_off
                    item_selection_off --
                while item_selection >= item_selection_off + items_display
                    item_selection_off ++
                
                item_selection_off = clamp(item_selection_off, 0, max(0, array_length(item_get_array(item_type)) - items_display))
                sell_prompt = false
            }
        }
        else {
            var items_display = 5
            var item_type = sell_options[selection].type
            var item_array = item_get_array(item_type)
            
            if InputRepeat(INPUT_VERB.DOWN)
                item_selection ++
            else if InputRepeat(INPUT_VERB.UP) 
                item_selection --
            
            item_selection = clamp(item_selection, 0, item_get_count(sell_options[selection].type)-1)
            
            while item_selection < item_selection_off
                item_selection_off --
            while item_selection >= item_selection_off + items_display
                item_selection_off ++
            
            item_selection_off = clamp(item_selection_off, 0, max(0, array_length(item_get_array(item_type)) - items_display))
            
            if InputPressed(INPUT_VERB.SELECT) {
                if !is_undefined(item_array[item_selection]) {
                    var __refuse = false
                    for (var i = 0; i < array_length(refuse_items); i ++) {
                        if is_instanceof(item_array[item_selection], refuse_items[i]) {
                            __refuse = true
                            break
                        }
                    }
                    if !__refuse
                        sell_prompt = true
                    else {
                        audio_play(snd_ui_cant_select)
                        talk_context = SHOP_TALK_CONTEXT.REFUSE
                    }
                    
                    instance_destroy(other.inst_small_talk)
                }
            }
            else if InputPressed(INPUT_VERB.CANCEL) {
                choosing_item = false
                talk_context = SHOP_TALK_CONTEXT.IDLE
                instance_destroy(other.inst_small_talk)
            }
        }
    })
    drawer = method(self, function() {
        if !choosing_item {
            for (var i = 0; i < array_length(sell_options); i ++) {
                if selection == i
                    draw_sprite_ext(spr_uisoul, 0, 50, 270 + 40*i, 1, 1, 0, c_red, 1)
                draw_text_transformed(80, 260 + 40*i, sell_options[i].name, 2, 2, 0)
            }
            
            // return
            if selection == array_length(sell_options)
                draw_sprite_ext(spr_uisoul, 0, 50, 430, 1, 1, 0, c_red, 1)
            draw_text_transformed(80, 420, loc("shop_option_return"), 2, 2, 0)
        }
        else {
            var items_display = 5
            var item_type = sell_options[selection].type
            var item_array = item_get_array(item_type)
            
            if array_length(item_array) > items_display {
                draw_set_color(c_dkgray)
                draw_rectangle(378, 299, 378+5, 418, 0)
                draw_set_color(c_white)
                
                var add = lerp(0, 120-5, item_selection_off / (array_length(item_array) - items_display))
                draw_rectangle(378, 299 + add, 378+5, 299 + 5 + add, 0)
                
                if item_selection_off < array_length(item_array) - items_display
                    draw_sprite_ext(spr_ui_arrow_down, 0, 375, 432 + round(sine(12, 3)), 1, 1, 0, c_white, 1)
                if item_selection_off > 0
                    draw_sprite_ext(spr_ui_arrow_up, 0, 375, 268 + round(sine(12, -3)), 1, 1, 0, c_white, 1)
            }
            
            for (var i = item_selection_off; i < min(array_length(item_array), item_selection_off + items_display); i ++) {
                var __item = item_array[i]
                
                if is_undefined(__item) {
                    draw_set_colour(c_dkgray)
                    draw_text_transformed(60, 260 + 40 * (i - item_selection_off), "-------", 2, 2, 0)
                    draw_set_colour(c_white)
                }
                else {
                    draw_text_transformed(60, 260 + 40 * (i - item_selection_off), item_get_name(__item), 2, 2, 0)
                    draw_text_xfit(300, 260 + 40 * (i - item_selection_off), $"${item_get_shop_sell_price(__item)}", 170, 2, 2)
                }
                
                if item_selection == i && !sell_prompt
                    draw_sprite_ext(spr_uisoul, 0, 30, 270 + 40 * (i - item_selection_off), 1, 1, 0, c_red, 1)
            }  
            
            if sell_prompt {
                var __item = item_array[item_selection]
                
                draw_set_font(loc_font("main"))
                draw_text_ext_transformed(460, 260, string(loc("shop_sell_prompt"), item_get_shop_sell_price(__item)), 16, 70, 2, 2, 0)
                
                draw_sprite_ext(spr_uisoul, 0, 450, 350 + sell_prompt_selection*30, 1, 1, 0, c_red, 1)
                
                draw_text_transformed(480, 340, loc("shop_query_yes"), 2, 2, 0)
                draw_text_transformed(480, 370, loc("shop_query_no"), 2, 2, 0)
            }
        }
    })
}

/// @arg {string|function} _name the name of the option
/// @arg {string|function} _answer the way the shopkeeper will answer. if a function, should create a cutscene and set `o_shop`'s `waiting` variable to true
function __shop_talk_option(_name, _answer) constructor {
    name = _name
    answer = _answer
    
    __answer_call = method(self, function() {
        if is_string(answer) || is_array(answer) {
            o_shop.menu_expanded = true
            
            cutscene_create()
            cutscene_set_variable(o_shop, "waiting", true)
            cutscene_dialogue(answer)
            cutscene_set_variable(o_shop, "waiting", false)
            cutscene_set_variable(o_shop, "menu_expanded", false)
            cutscene_play()
        }
        else if is_callable(answer) {
            o_shop.menu_expanded = true
            answer()
        }
    })
}
/// @desc constructor for the shop option "talk"
/// @arg {array<struct>} _talk_options an array of talk options. each talk 
/// @arg {function} _talk_gen a function that returns a sidebar response. given context as argument 0 (see `SHOP_TALK_CONTEXT`)
function shop_option_talk(_talk_options, _talk_gen) : shop_option() constructor {
    name = loc("shop_option_talk")
    
    talk_options = _talk_options
    talk_context = SHOP_TALK_CONTEXT.IDLE
    talk_gen = _talk_gen
    
    cancel = method(self, function() {
        other.menu_in_options = true
        talk_context = SHOP_TALK_CONTEXT.IDLE
    })
    
    selection = 0
    
    step = method(self, function() {
        if !instance_exists(other.inst_small_talk) && !other.__get_waiting()
            other.inst_small_talk = text_typer_create(talk_gen(talk_context), 
                450, 260, DEPTH_UI.MENU_UI, 
                other.shop_data.flavor_prefix, "", {
                    gui: true,
                    can_superskip: false,
                    max_width: 160,
                    break_tabulation: false
                }
            )
        
        if !other.__get_waiting() {
            if InputPressed(INPUT_VERB.DOWN)
                selection ++
            else if InputPressed(INPUT_VERB.UP)
                selection --
            
            if InputPressed(INPUT_VERB.SELECT) {
                instance_destroy(other.inst_small_talk)
                
                if selection == array_length(talk_options)
                    cancel()
                else {
                    talk_options[selection].__answer_call()
                }
            }
            
            if InputPressed(INPUT_VERB.CANCEL)
                cancel()
            
            selection = cap_wraparound(selection, array_length(talk_options) + 1)
        }
    })
    drawer = method(self, function() {
        if !other.__get_waiting() {
            for (var i = 0; i < array_length(talk_options); i ++) {
                if selection == i
                    draw_sprite_ext(spr_uisoul, 0, 50, 270 + 40*i, 1, 1, 0, c_red, 1)
                draw_text_transformed(80, 260 + 40*i, talk_options[i].name, 2, 2, 0)
            }
            
            // return
            if selection == array_length(talk_options)
                draw_sprite_ext(spr_uisoul, 0, 50, 430, 1, 1, 0, c_red, 1)
            draw_text_transformed(80, 420, loc("shop_option_exit"), 2, 2, 0)
        }
    })
    
}

/// @desc 
/// @arg {function|string|array<string>} _exit_call if a function, will be simply called. if a string or an array, will be displayed as dialogue
function shop_option_exit(_exit_call) : shop_option() constructor {
    name = loc("shop_option_exit")
    exit_call = _exit_call
    
    return_marker_id = 0
    return_direction = undefined
    
    use = method(self, function() {
        o_shop.menu_expanded = true
            
        cutscene_create()
        cutscene_set_variable(o_shop, "waiting", true)
        
        if is_string(exit_call) || is_array(exit_call)
            cutscene_dialogue(exit_call)
        else 
            exit_call()
        
        cutscene_func(fader_fade, [0, 1, 15])
        cutscene_func(music_fade, [0, 0, 30])
        cutscene_sleep(30)
        
        cutscene_func(music_slot_reset, [0])
        cutscene_func(method(self, function() {
            return_marker_id = o_shop.shop_data.return_marker_id
            return_direction = o_shop.shop_data.return_direction
            
            room_goto(o_shop.shop_data.return_room)
            
            call_later(1, time_source_units_frames, method(self, function() {
                if instance_exists(get_leader()) {
                	var marker = marker_get("land", return_marker_id)
                    
                	if instance_exists(marker) {
                		get_leader().x = marker.x
                		get_leader().y = marker.y
                        
                		get_leader().dir = return_direction ?? DIR.DOWN
                	}
                	for (var i = 0; i < array_length(global.party_names); ++i) {
                	    with party_get_inst(global.party_names[i]) {
                			x = get_leader().x
                			y = get_leader().y
                			dir = get_leader().dir
                			
                			event_user(1)
                		}
                	}
                }
                
                call_later(1, time_source_units_frames, function() {
                    fader_fade(1, 0, 10)
                })
            }))
        }))
        
        cutscene_play()
    })
}