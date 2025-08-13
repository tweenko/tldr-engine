/// @description fade out
do_anime(y+6, y+6 - 30, 10, "linear", function(v) {if instance_exists(id) id.y = v})
do_anime(1, 2, 10, "linear", function(v) {if instance_exists(id) id.image_yscale = v})
do_anime(1, 0, 10, "linear", function(v) {if instance_exists(id) id.image_alpha = v})