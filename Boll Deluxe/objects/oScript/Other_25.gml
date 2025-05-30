node_init_post()

if (script_onCreate!= "") {
	catspeak_execute(global.scripts_level[? $"{script_onCreate}"]);
}