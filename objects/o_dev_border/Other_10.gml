var ref = asset_get_index(_border_name)
if !is_callable(ref)
    exit

global.current_dynamic_border = ref
if global.border_mode == BORDER_MODE.DYNAMIC
    border_set(ref)