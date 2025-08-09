active = false
console_caller = function() {
	return keyboard_check_pressed(vk_tab)
}

registred_commands = {
	h: {
		name: "help",
		desc: "Helps you, apparently.",
		
		execute: function() {
			var _msg = "\nBelow are the keys you can use with [Tab] and what they do.\n"
			var __nms = struct_get_names(o_console.registred_commands)
			
			for (var i = 0; i < array_length(__nms); ++i) {
				var __cmd = struct_get(o_console.registred_commands, __nms[i])
				
				_msg += $"[{string_upper(__nms[i])}] {__cmd.name} : {__cmd.desc}" + "\n"
			}
			
			show_debug_message(_msg)
		}
	},
	r: {
		name: "room_select",
		desc: "Lets you select a room to be transported to instantly.",
		execute: function(){
			instance_create(o_dev_roomselect)
		}
	},
	p: {
		name: "party_select",
		desc: "Lets you select the party members you desire to be part of your team.",
		execute: function(){
			instance_create(o_dev_partyselect)
		}
	},
	e: {
		name: "encounter_select",
		desc: "Lets you initiate an encounter from the console instantly.",
		execute: function(){
			instance_create(o_dev_encselect)
		}
	},
}

depth = DEPTH_UI.CONSOLE

keyhold = 0
curcommand = function() {}