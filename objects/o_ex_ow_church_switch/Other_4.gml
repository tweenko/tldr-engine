state = memory_get("switches", id) ?? false;
layer_set_visible("tile_reveal", state);

if !state
    instance_deactivate_layer("inst_climb_reveal");
else {
    image_blend = c_gray;
    image_index = 1;
}