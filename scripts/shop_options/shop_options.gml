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
        box_h = 100
    })
    cancel = method(self, function() {
        other.menu_in_options = true
    })
    
    box_h = 180
    step = method(self, function() {
        #region replicate deltarune's box height calculation
        var box_y = 240 - box_h
        if other.selection < array_length(items) {
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
        with other {
            if !instance_exists(inst_small_talk)
                inst_small_talk = text_typer_create(other.talk_gen(other.talk_context), 
                    450, 260, DEPTH_UI.MENU_UI, 
                    shop_data.flavor_prefix, "", {
                        gui: true,
                        can_superskip: false,
                        max_width: 170,
                        break_tabulation: false
                    }
                )
            
            if InputPressed(INPUT_VERB.DOWN)
                selection ++
            else if InputPressed(INPUT_VERB.UP)
                selection --
            
            if InputPressed(INPUT_VERB.SELECT) {
                if save_get("money") < other.items[selection]
                    exit
                else {
                    
                }
            }
            
            selection = cap_wraparound(selection, array_length(other.items) + 1)
        }
    })
    
    surf_item_info = -1
    drawer = method(self, function() {
        var selection = other.selection
        
        var item_type = ITEM_TYPE.CONSUMABLE
        var space = 0
        var array = []
        
        // if the item is valid, assign type, space and array
        if selection < array_length(items) {
            item_type = item_get_type(items[selection])
            space = item_get_maxcount(item_type) 
            array = item_get_array(item_type)
        }
        
        draw_set_font(loc_font("main"))
        for (var i = 0; i < array_length(items); i ++) {
            draw_text_transformed(60, 260 + 40*i, item_get_name(items[i]), 2, 2, 0)
            draw_text_xfit(300, 260 + 40*i, $"${item_get_shop_cost(items[i])}", 170, 2, 2)
            
            if selection == i
                draw_sprite_ext(spr_uisoul, 0, 30, 270 + 40*i, 1, 1, 0, c_red, 1)
        }
        
        // exit
        if selection == array_length(items)
            draw_sprite_ext(spr_uisoul, 0, 30, 430, 1, 1, 0, c_red, 1)
        draw_text_transformed(60, 420, "Exit", 2, 2, 0)
        
        draw_set_font(loc_font("enc"))
        if !is_undefined(space) && !is_undefined(array)
            draw_text(520, 430, $"Space: {space - array_length(array)}")
        
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