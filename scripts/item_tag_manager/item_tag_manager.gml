#macro TLDR_AssetTag_item "TLDR_inventory_item"

#macro TLDR_AssetTag_item_unknown "TLDR_inventory_item_unknown"
#macro TLDR_AssetTag_item_consumable "TLDR_inventory_item_consumable"
#macro TLDR_AssetTag_item_weapon "TLDR_inventory_item_weapon"
#macro TLDR_AssetTag_item_armor "TLDR_inventory_item_armor"
#macro TLDR_AssetTag_item_spell "TLDR_inventory_item_spell"
#macro TLDR_AssetTag_item_key "TLDR_inventory_item_key"
#macro TLDR_AssetTag_item_light "TLDR_inventory_item_light"

/// @desc adds `TLDR_AssetTag_item` tag and its type tag to an item asset
/// @arg {Asset.GMScript} _item_ref
function item_register(_item_ref) {
    var type_tag = TLDR_AssetTag_item_unknown;
    switch item_get_type(_item_ref) {
        case ITEM_TYPE.CONSUMABLE:
            type_tag = TLDR_AssetTag_item_consumable;
            break;
        case ITEM_TYPE.WEAPON:
            type_tag = TLDR_AssetTag_item_weapon;
            break;
        case ITEM_TYPE.ARMOR:
            type_tag = TLDR_AssetTag_item_armor;
            break;
        case ITEM_TYPE.SPELL:
            type_tag = TLDR_AssetTag_item_spell;
            break;
        case ITEM_TYPE.KEY:
            type_tag = TLDR_AssetTag_item_key;
            break;
        case ITEM_TYPE.LIGHT:
            type_tag = TLDR_AssetTag_item_light;
            break;
    }
    
    asset_add_tags(_item_ref, [TLDR_AssetTag_item, type_tag]);
}