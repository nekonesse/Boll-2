node_init_post()

if (script_onCreate!= "") {
	txr_exec(global.scripts_level[? $"{script_onCreate}"]);
}