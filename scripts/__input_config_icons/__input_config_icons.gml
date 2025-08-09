// Feather disable all

/// This script contains mappings from binding labels - a combination of keyboard key names, mouse button
/// names, and abstract gamepad names - to more friendly terms that you can show a player. Typically you'd
/// set up this function to return sprites such that you can draw gamepad icons as visual icons.
/// 
/// Default values in this script reflect the particular, and sometimes unexpected, buttons that each gamepad
/// binding maps to on the actual physical hardware. There are a handful of special cases at the top of the
/// script that are used to handle errors or misconfigurations.



//Special case: When a non-binding value is being evaluated
//              This should only happen if Input is given an invalid input argument
input_icon_not_a_binding("Not a binding");

//Special case: When an empty binding is being evaluated
input_icon_empty("Empty");

//Special case: When a touch binding (virtual button) is being evaluated
input_icon_touch("Virtual button");



//Optional remapping for keyboard and mouse
//This is useful for turning keyboard keys into sprite icons to match other assets, or for returning formatted strings (e.g. for use with Scribble)
//Any keyboard key label not in this struct will simply fall through and return the key name
input_icons_keyboard_and_mouse()
//Put extra .add() commands here to add icons to keyboard and mouse



#region Gamepads

//Xbox One and Series S|X controllers
input_icons_gamepad(INPUT_GAMEPAD_TYPE_XBOX_ONE)
.add("gamepad face south",         spr_ui_gp_xbox_a)
.add("gamepad face east",          spr_ui_gp_xbox_b)
.add("gamepad face west",          spr_ui_gp_xbox_x)
.add("gamepad face north",         spr_ui_gp_xbox_y)
.add("gamepad shoulder l",         spr_ui_gp_xbox_lb)
.add("gamepad shoulder r",         spr_ui_gp_xbox_rb)
.add("gamepad trigger l",          spr_ui_gp_xbox_lt)
.add("gamepad trigger r",          spr_ui_gp_xbox_rt)
.add("gamepad select",             "view")
.add("gamepad start",              spr_ui_gp_xbox_options)
.add("gamepad dpad left",          spr_ui_gp_xbox_left)
.add("gamepad dpad right",         spr_ui_gp_xbox_right)
.add("gamepad dpad up",            spr_ui_gp_xbox_up)
.add("gamepad dpad down",          spr_ui_gp_xbox_down)

.add("gamepad thumbstick l left",  spr_ui_gp_lstick_left)
.add("gamepad thumbstick l right", spr_ui_gp_lstick_right)
.add("gamepad thumbstick l up",    spr_ui_gp_lstick_up)
.add("gamepad thumbstick l down",  spr_ui_gp_lstick_down)
.add("gamepad thumbstick l click", spr_ui_gp_xbox_ls)

.add("gamepad thumbstick r left",  spr_ui_gp_rstick_left)
.add("gamepad thumbstick r right", spr_ui_gp_rstick_right)
.add("gamepad thumbstick r up",    spr_ui_gp_rstick_up)
.add("gamepad thumbstick r down",  spr_ui_gp_rstick_down)
.add("gamepad thumbstick r click", spr_ui_gp_xbox_rs)

//Series S|X only
.add("gamepad misc 1",             "share")

//Elite and third party controllers
.add("gamepad paddle 1",           "P1")
.add("gamepad paddle 2",           "P2")
.add("gamepad paddle 3",           "P3")
.add("gamepad paddle 4",           "P4")

//PlayStation 5
input_icons_gamepad(INPUT_GAMEPAD_TYPE_PS5)
.add("gamepad face south",         spr_ui_gp_ps4_cross)
.add("gamepad face east",          spr_ui_gp_ps4_circle)
.add("gamepad face west",          spr_ui_gp_ps4_square)
.add("gamepad face north",         spr_ui_gp_ps4_triangle)
.add("gamepad shoulder l",         spr_ui_gp_ps4_l1)
.add("gamepad shoulder r",         spr_ui_gp_ps4_r1)
.add("gamepad trigger l",          spr_ui_gp_ps4_l2)
.add("gamepad trigger r",          spr_ui_gp_ps4_r2)
.add("gamepad select",             "create")
.add("gamepad start",              spr_ui_gp_ps4_options)
.add("gamepad dpad left",          spr_ui_gp_ps4_left)
.add("gamepad dpad right",         spr_ui_gp_ps4_right)
.add("gamepad dpad up",            spr_ui_gp_ps4_up)
.add("gamepad dpad down",          spr_ui_gp_ps4_down)

.add("gamepad thumbstick l left",  spr_ui_gp_lstick_left)
.add("gamepad thumbstick l right", spr_ui_gp_lstick_right)
.add("gamepad thumbstick l up",    spr_ui_gp_lstick_up)
.add("gamepad thumbstick l down",  spr_ui_gp_lstick_down)
.add("gamepad thumbstick l click", spr_ui_gp_ps4_l3)

.add("gamepad thumbstick r left",  spr_ui_gp_rstick_left)
.add("gamepad thumbstick r right", spr_ui_gp_rstick_right)
.add("gamepad thumbstick r up",    spr_ui_gp_rstick_up)
.add("gamepad thumbstick r down",  spr_ui_gp_rstick_down)
.add("gamepad thumbstick r click", spr_ui_gp_ps4_r3)

.add("gamepad touchpad click",     spr_ui_gp_ps4_touchpad)

//Not available on the PlayStation 5 console itself but available on other platforms
.add("gamepad misc 1",             "mic")

//DualSense Edge
.add("gamepad paddle 1",           "RB")
.add("gamepad paddle 2",           "LB")

//Switch handheld/dual JoyCon/Pro Controller
input_icons_gamepad(INPUT_GAMEPAD_TYPE_SWITCH)
.add("gamepad face south",		   spr_ui_gp_switch_b)
.add("gamepad face east",          spr_ui_gp_switch_a)
.add("gamepad face west",          spr_ui_gp_switch_y)
.add("gamepad face north",         spr_ui_gp_switch_x)
.add("gamepad shoulder l",         spr_ui_gp_switch_l)
.add("gamepad shoulder r",         spr_ui_gp_switch_r)
.add("gamepad trigger l",          spr_ui_gp_switch_zl)
.add("gamepad trigger r",          spr_ui_gp_switch_zr)
.add("gamepad select",             spr_ui_gp_switch_min)
.add("gamepad start",              spr_ui_gp_switch_plus)
.add("gamepad dpad left",          spr_ui_gp_switch_left)
.add("gamepad dpad right",         spr_ui_gp_switch_right)
.add("gamepad dpad up",            spr_ui_gp_switch_up)
.add("gamepad dpad down",          spr_ui_gp_switch_down)

.add("gamepad thumbstick l left",  spr_ui_gp_lstick_left)
.add("gamepad thumbstick l right", spr_ui_gp_lstick_right)
.add("gamepad thumbstick l up",    spr_ui_gp_lstick_up)
.add("gamepad thumbstick l down",  spr_ui_gp_lstick_down)
.add("gamepad thumbstick l click", spr_ui_gp_switch_l3)
 
.add("gamepad thumbstick r left",  spr_ui_gp_rstick_left)
.add("gamepad thumbstick r right", spr_ui_gp_rstick_right)
.add("gamepad thumbstick r up",    spr_ui_gp_rstick_up)
.add("gamepad thumbstick r down",  spr_ui_gp_rstick_down)
.add("gamepad thumbstick r click", spr_ui_gp_switch_r3)
  
//Not available on the Switch console itself but available on other platforms
.add("gamepad guide",              spr_ui_gp_switch_home)
.add("gamepad misc 1",             spr_ui_gp_switch_capture)

//Left-hand Switch JoyCon
//This setup assums horizontal hold type
input_icons_gamepad(INPUT_GAMEPAD_TYPE_JOYCON_LEFT)
.add("gamepad face south",         spr_ui_gp_switch_down)
.add("gamepad face east",          spr_ui_gp_switch_right)
.add("gamepad face west",          spr_ui_gp_switch_left) 
.add("gamepad face north",         spr_ui_gp_switch_up)
.add("gamepad shoulder l",         spr_ui_gp_switch_sl)
.add("gamepad shoulder r",         spr_ui_gp_switch_sr)
.add("gamepad start",              spr_ui_gp_switch_min)

.add("gamepad thumbstick l left",  spr_ui_gp_lstick_left)
.add("gamepad thumbstick l right", spr_ui_gp_lstick_right)
.add("gamepad thumbstick l up",    spr_ui_gp_lstick_up)
.add("gamepad thumbstick l down",  spr_ui_gp_lstick_down)
.add("gamepad thumbstick l click", spr_ui_gp_switch_l3)

//Not available on the Switch console itself but available on other platforms
.add("gamepad select",             spr_ui_gp_switch_capture)

//Right-hand Switch JoyCon
//This setup assums horizontal hold type
input_icons_gamepad(INPUT_GAMEPAD_TYPE_JOYCON_RIGHT)
.add("gamepad face south",         spr_ui_gp_switch_b)
.add("gamepad face east",          spr_ui_gp_switch_a)
.add("gamepad face west",          spr_ui_gp_switch_y) 
.add("gamepad face north",         spr_ui_gp_switch_x)
.add("gamepad shoulder l",         spr_ui_gp_switch_sl)
.add("gamepad shoulder r",         spr_ui_gp_switch_sr)
.add("gamepad start",              spr_ui_gp_switch_plus)

.add("gamepad thumbstick l left",  spr_ui_gp_lstick_left)
.add("gamepad thumbstick l right", spr_ui_gp_lstick_right)
.add("gamepad thumbstick l up",    spr_ui_gp_lstick_up)
.add("gamepad thumbstick l down",  spr_ui_gp_lstick_down)
.add("gamepad thumbstick l click", spr_ui_gp_switch_l3)

//Not available on the Switch console itself but available on other platforms
.add("gamepad select",             spr_ui_gp_switch_home)

//Xbox 360
input_icons_gamepad(INPUT_GAMEPAD_TYPE_XBOX_360)
.add("gamepad face south",         spr_ui_gp_xbox_a)
.add("gamepad face east",          spr_ui_gp_xbox_b)
.add("gamepad face west",          spr_ui_gp_xbox_x)
.add("gamepad face north",         spr_ui_gp_xbox_y)
.add("gamepad shoulder l",         spr_ui_gp_xbox_lb)
.add("gamepad shoulder r",         spr_ui_gp_xbox_rb)
.add("gamepad trigger l",          spr_ui_gp_xbox_lt)
.add("gamepad trigger r",          spr_ui_gp_xbox_rt)
.add("gamepad select",             "back")
.add("gamepad start",              "start")
.add("gamepad dpad left",          spr_ui_gp_xbox_left)
.add("gamepad dpad right",         spr_ui_gp_xbox_right)
.add("gamepad dpad up",            spr_ui_gp_xbox_up)
.add("gamepad dpad down",          spr_ui_gp_xbox_down)

.add("gamepad thumbstick l left",  spr_ui_gp_lstick_left)
.add("gamepad thumbstick l right", spr_ui_gp_lstick_right)
.add("gamepad thumbstick l up",    spr_ui_gp_lstick_up)
.add("gamepad thumbstick l down",  spr_ui_gp_lstick_down)
.add("gamepad thumbstick l click", spr_ui_gp_xbox_ls)

.add("gamepad thumbstick r left",  spr_ui_gp_rstick_left)
.add("gamepad thumbstick r right", spr_ui_gp_rstick_right)
.add("gamepad thumbstick r up",    spr_ui_gp_rstick_up)
.add("gamepad thumbstick r down",  spr_ui_gp_rstick_down)
.add("gamepad thumbstick r click", spr_ui_gp_xbox_rs)

//PlayStation 4
input_icons_gamepad(INPUT_GAMEPAD_TYPE_PS4)
.add("gamepad face south",         spr_ui_gp_ps4_cross)
.add("gamepad face east",          spr_ui_gp_ps4_circle)
.add("gamepad face west",          spr_ui_gp_ps4_square)
.add("gamepad face north",         spr_ui_gp_ps4_triangle)
.add("gamepad shoulder l",         spr_ui_gp_ps4_l1)
.add("gamepad shoulder r",         spr_ui_gp_ps4_r1)
.add("gamepad trigger l",          spr_ui_gp_ps4_l2)
.add("gamepad trigger r",          spr_ui_gp_ps4_r2)
.add("gamepad select",             "share")
.add("gamepad start",              spr_ui_gp_ps4_options)
.add("gamepad dpad left",          spr_ui_gp_ps4_left)
.add("gamepad dpad right",         spr_ui_gp_ps4_right)
.add("gamepad dpad up",            spr_ui_gp_ps4_up)
.add("gamepad dpad down",          spr_ui_gp_ps4_down)

.add("gamepad thumbstick l left",  spr_ui_gp_lstick_left)
.add("gamepad thumbstick l right", spr_ui_gp_lstick_right)
.add("gamepad thumbstick l up",    spr_ui_gp_lstick_up)
.add("gamepad thumbstick l down",  spr_ui_gp_lstick_down)
.add("gamepad thumbstick l click", spr_ui_gp_ps4_l3)

.add("gamepad thumbstick r left",  spr_ui_gp_rstick_left)
.add("gamepad thumbstick r right", spr_ui_gp_rstick_right)
.add("gamepad thumbstick r up",    spr_ui_gp_rstick_up)
.add("gamepad thumbstick r down",  spr_ui_gp_rstick_down)
.add("gamepad thumbstick r click", spr_ui_gp_ps4_r3)

.add("gamepad touchpad click", spr_ui_gp_ps4_touchpad)

//PlayStation 1-3
input_icons_gamepad(INPUT_GAMEPAD_TYPE_PSX)
.add("gamepad face south",         "cross")
.add("gamepad face east",          "circle")
.add("gamepad face west",          "square")
.add("gamepad face north",         "triangle")
.add("gamepad shoulder l",         "L1")
.add("gamepad shoulder r",         "R1")
.add("gamepad trigger l",          "L2")
.add("gamepad trigger r",          "R2")
.add("gamepad select",             "select")
.add("gamepad start",              "start")
.add("gamepad dpad left",          "dpad left")
.add("gamepad dpad right",         "dpad right")
.add("gamepad dpad up",            "dpad up")
.add("gamepad dpad down",          "dpad down")

.add("gamepad thumbstick l left",  "thumbstick l left")
.add("gamepad thumbstick l right", "thumbstick l right")
.add("gamepad thumbstick l up",    "thumbstick l up")
.add("gamepad thumbstick l down",  "thumbstick l down")
.add("gamepad thumbstick l click", "L3")

.add("gamepad thumbstick r left",  "thumbstick r left")
.add("gamepad thumbstick r right", "thumbstick r right")
.add("gamepad thumbstick r up",    "thumbstick r up")
.add("gamepad thumbstick r down",  "thumbstick r down")
.add("gamepad thumbstick r click", "R3")

//Nintendo Gamecube
input_icons_gamepad(INPUT_GAMEPAD_TYPE_GAMECUBE)
.add("gamepad face south",         "A")
.add("gamepad face east",          "X")
.add("gamepad face west",          "B")
.add("gamepad face north",         "Y")
.add("gamepad shoulder r",         "Z")
.add("gamepad trigger l",          "L")
.add("gamepad trigger r",          "R")
.add("gamepad start",              "start")
.add("gamepad dpad left",          "dpad left")
.add("gamepad dpad right",         "dpad right")
.add("gamepad dpad up",            "dpad up")
.add("gamepad dpad down",          "dpad down")

.add("gamepad thumbstick l left",  "thumbstick l left")
.add("gamepad thumbstick l right", "thumbstick l right")
.add("gamepad thumbstick l up",    "thumbstick l up")
.add("gamepad thumbstick l down",  "thumbstick l down")

.add("gamepad thumbstick r left",  "thumbstick r left")
.add("gamepad thumbstick r right", "thumbstick r right")
.add("gamepad thumbstick r up",    "thumbstick r up")
.add("gamepad thumbstick r down",  "thumbstick r down")

//The following icons are for Switch GameCube controllers and adapters only
.add("gamepad thumbstick l click", "thumbstick l click")
.add("gamepad thumbstick r click", "thumbstick r click")
.add("gamepad guide",              "home")
.add("gamepad misc 1",             "capture")

////A couple additional examples for optional gamepad types (see __input_define_gamepad_types)
//
////Nintendo 64
//input_icons(INPUT_GAMEPAD_TYPE_N64)
//.add("gamepad face south",         "A")
//.add("gamepad face east",          "B")
//.add("gamepad shoulder l",         "L")
//.add("gamepad shoulder r",         "R")
//.add("gamepad trigger l",          "Z")
//.add("gamepad start",              "start")
//.add("gamepad dpad up",            "dpad up")
//.add("gamepad dpad down",          "dpad down")
//.add("gamepad dpad left",          "dpad left")
//.add("gamepad dpad right",         "dpad right")
//.add("gamepad thumbstick l left",  "thumbstick left")
//.add("gamepad thumbstick l right", "thumbstick right")
//.add("gamepad thumbstick l up",    "thumbstick up")
//.add("gamepad thumbstick l down",  "thumbstick down")
//.add("gamepad thumbstick r left",  "C left")
//.add("gamepad thumbstick r right", "C right")
//.add("gamepad thumbstick r up",    "C up")
//.add("gamepad thumbstick r down",  "C down")
//
////Sega Saturn
//input_icons(INPUT_GAMEPAD_TYPE_SATURN)
//.add("gamepad face south", "A")
//.add("gamepad face east",  "B")
//.add("gamepad face west",  "X")
//.add("gamepad face north", "Y")
//.add("gamepad shoulder l", "L")
//.add("gamepad shoulder r", "Z")
//.add("gamepad trigger l",  "R")
//.add("gamepad trigger r",  "C")
//.add("gamepad select",     "mode")
//.add("gamepad start",      "start")
//.add("gamepad dpad up",    "dpad up")
//.add("gamepad dpad down",  "dpad down")
//.add("gamepad dpad left",  "dpad left")
//.add("gamepad dpad right", "dpad right")

#endregion
