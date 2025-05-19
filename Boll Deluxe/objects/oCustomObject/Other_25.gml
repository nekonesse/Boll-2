node_init_post()

if !is_undefined(global.scripts_object[? $"{script_name}_create"])
txr_exec(global.scripts_object[? $"{script_name}_create"]);