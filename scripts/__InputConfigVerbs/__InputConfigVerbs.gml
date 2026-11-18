function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Add your own verbs here!
        UP,
        DOWN,
        LEFT,
        RIGHT,
        SELECT,
        CANCEL,
        SPECIAL,
		OTHER,
        MAP,
    }
    
    enum INPUT_CLUSTER
    {
        //Add your own clusters here!
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        NAVIGATION,
    }
    
    InputDefineVerb(INPUT_VERB.UP,      "UP",         [vk_up,    "W"],      [-gp_axislv, gp_padu]);
    InputDefineVerb(INPUT_VERB.DOWN,    "DOWN",       [vk_down,  "S"],      [ gp_axislv, gp_padd]);
    InputDefineVerb(INPUT_VERB.LEFT,    "LEFT",       [vk_left,  "A"],      [-gp_axislh, gp_padl]);
    InputDefineVerb(INPUT_VERB.RIGHT,   "RIGHT",      [vk_right, "D"],      [ gp_axislh, gp_padr]);
    InputDefineVerb(INPUT_VERB.SELECT,  "CONFIRM",    ["Z", vk_enter],      INPUT_ON_SWITCH_X ? gp_face2 : gp_face1);
    InputDefineVerb(INPUT_VERB.CANCEL,  "CANCEL",     ["X", vk_shift],      INPUT_ON_SWITCH_X ? gp_face1 : gp_face2);
	InputDefineVerb(INPUT_VERB.SPECIAL, "MENU",       ["C", vk_control],    gp_face4);
    InputDefineVerb(INPUT_VERB.OTHER,   "OTHER",      ["V", vk_alt],        gp_face3);
	InputDefineVerb(INPUT_VERB.MAP,     "MAP",        ["M", vk_backspace],  INPUT_ON_PS5 ? gp_touchpadbutton : gp_select);
    
    //Define a cluster of verbs for moving around
    InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}
