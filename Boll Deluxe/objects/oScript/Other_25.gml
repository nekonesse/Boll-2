txr_exec(global.scripts_level[? $"{script_onCreate}"]);
show_debug_message("ran script" + string(id))


//show_debug_message(string(global.scripts_level[? $"{script_onCreate}"]))
//show_debug_message(string(global.scripts_level[? $"{script_onStep}"]))
//show_debug_message()

show_debug_message(script_onCreate)
show_debug_message(script_onStep)
show_debug_message(script_onTrigger)