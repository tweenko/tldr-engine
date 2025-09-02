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
    }
    
    enum INPUT_CLUSTER
    {
        //Add your own clusters here!
        //Clusters are used for two-dimensional checkers (InputDirection() etc.)
        NAVIGATION,
    }
    
    if (not INPUT_ON_SWITCH)
    {
        InputDefineVerb(INPUT_VERB.UP,      "UP",         vk_up,    [-gp_axislv, gp_padu]);
        InputDefineVerb(INPUT_VERB.DOWN,    "DOWN",       vk_down,    [ gp_axislv, gp_padd]);
        InputDefineVerb(INPUT_VERB.LEFT,    "LEFT",       vk_left,    [-gp_axislh, gp_padl]);
        InputDefineVerb(INPUT_VERB.RIGHT,   "RIGHT",      vk_right,    [ gp_axislh, gp_padr]);
        InputDefineVerb(INPUT_VERB.SELECT,  "CONFIRM",     ["Z", vk_enter],        gp_face1);
        InputDefineVerb(INPUT_VERB.CANCEL,  "CANCEL",     ["X", vk_shift],        gp_face2);
        InputDefineVerb(INPUT_VERB.SPECIAL, "MENU",    ["C", vk_control],      gp_face4);
    }
    else //Flip A/B over on Switch
    {
        InputDefineVerb(INPUT_VERB.UP,      "UP",      undefined, [-gp_axislv, gp_padu]);
        InputDefineVerb(INPUT_VERB.DOWN,    "DOWN",    undefined, [ gp_axislv, gp_padd]);
        InputDefineVerb(INPUT_VERB.LEFT,    "LEFT",    undefined, [-gp_axislh, gp_padl]);
        InputDefineVerb(INPUT_VERB.RIGHT,   "RIGHT",   undefined, [ gp_axislh, gp_padr]);
        InputDefineVerb(INPUT_VERB.SELECT,  "CONFIRM",  undefined,   gp_face2); // !!
        InputDefineVerb(INPUT_VERB.CANCEL,  "CANCEL",  undefined,   gp_face1); // !!
        InputDefineVerb(INPUT_VERB.SPECIAL, "MENU", undefined,   gp_face4);
    }
    
    //Define a cluster of verbs for moving around
    InputDefineCluster(INPUT_CLUSTER.NAVIGATION, INPUT_VERB.UP, INPUT_VERB.RIGHT, INPUT_VERB.DOWN, INPUT_VERB.LEFT);
}
