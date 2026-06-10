enum BULLET_COLOR {
    SOLID,
    BLUE,
    ORANGE
}

graze = 2; // how many graze points the bullet should give upon first contact
att = 6; // what attack stat to base the damage off
inv = ENC_SETUP_SOUL_INV; // how many invincibility frames the bullet should give upon damage
time_points = 5; // how many time points the bullet should award for grazing (reduce turn length)

color = BULLET_COLOR.SOLID; // the color of the bullet
destroy = true; // whether the bullet should be destroyed after being hit
element = ""; // the element the bullet uses. for element reduction
inside = false; // whether the bullet should be drawn inside the box