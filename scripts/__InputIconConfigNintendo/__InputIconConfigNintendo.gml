// Feather disable all

////////////////
//            //
//  Nintendo  //
//            //
////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face1, spr_ui_gp_switch_b); //B
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face2, spr_ui_gp_switch_a); //A
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face3, spr_ui_gp_switch_y); //Y
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_face4, spr_ui_gp_switch_x); //X

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderl,  spr_ui_gp_switch_l ); //L
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderr,  spr_ui_gp_switch_r ); //R
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderlb, spr_ui_gp_switch_zl); //ZL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_shoulderrb, spr_ui_gp_switch_zr); //ZR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_select, spr_ui_gp_switch_min); //Minus
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_start,  spr_ui_gp_switch_plus ); //Plus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padl, spr_ui_gp_switch_left ); //D-pad left
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padr, spr_ui_gp_switch_right); //D-pad right
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padu, spr_ui_gp_switch_up   ); //D-pad up
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_padd, spr_ui_gp_switch_down ); //D-pad down

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axislh, spr_ui_gp_lstick_left );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axislh, spr_ui_gp_lstick_right);
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axislv, spr_ui_gp_lstick_up   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axislv, spr_ui_gp_lstick_down );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_stickl, spr_ui_gp_switch_l3);

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axisrh, spr_ui_gp_rstick_left );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axisrh, spr_ui_gp_rstick_right);
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, -gp_axisrv, spr_ui_gp_rstick_up   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_axisrv, spr_ui_gp_rstick_down );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH,  gp_stickr, spr_ui_gp_switch_r3);

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_home,   "home");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_extra1, "capture");

//Switch 2
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_extra2,  "C" ); //GameChat
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_paddlel, "GL"); //Grip Left
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_SWITCH, gp_paddler, "GR"); //Grip Right



///////////////////
//               //
//  Left JoyCon  //
//               //
///////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face1, "face south"); //Face South
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face2, "face east" ); //Face East
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face3, "face west" ); //Face West
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_face4, "face north"); //Face North

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_shoulderl, "SL"); //SL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_shoulderr, "SR"); //SR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_start, "minus"); //Minus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, -gp_axislh, "thumbstick left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_axislh, "thumbstick right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, -gp_axislv, "thumbstick up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_axislv, "thumbstick down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT,  gp_stickl, "thumbstick click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT, gp_select, "capture"); //Capture



////////////////////
//                //
//  Right JoyCon  //
//                //
////////////////////

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face1, "face south"); //Face South
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face2, "face east" ); //Face East
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face3, "face west" ); //Face West
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_face4, "face north"); //Face North

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_shoulderl, "SL"); //SL
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_shoulderr, "SR"); //SR

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_start, "plus"); //Plus

InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, -gp_axislh, "thumbstick left" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_axislh, "thumbstick right");
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, -gp_axislv, "thumbstick up"   );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_axislv, "thumbstick down" );
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT,  gp_stickl, "thumbstick click");

//Not available on the Switch console itself but available on other platforms
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_select, "home"); //Home
InputIconDefineGamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT, gp_extra2, "C"   ); //Switch 2 GameChat