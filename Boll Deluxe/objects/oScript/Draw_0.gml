if global.jade_testing || global.debug draw_self();

if script_onDraw != "" {	
	txr_exec(global.scripts_level[? $"{script_onDraw}"]);	
}