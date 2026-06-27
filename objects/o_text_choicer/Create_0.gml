choices = [
    new text_typer_choice("Yes"),
    new text_typer_choice("No"),
];

caller = noone;
selection = -1;
on = false;
vert_xpos = 0;

box_height = 151;
modern_choicer = true; // from ch5 and onward

x -= 26;
y -= 20;

soul_x = x + 320 - 26;
soul_y = y + 58/151 * box_height;
target_x = soul_x;
target_y = soul_y;

alarm[0] = 2;
visible = false;