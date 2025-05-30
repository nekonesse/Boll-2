node_init_post()

if !is_undefined(global.scripts_object[? $"{script_name}_create"])
catspeak_execute(global.scripts_object[? $"{script_name}_create"]);