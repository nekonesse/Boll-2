if global.jade_testing || global.debug draw_self();

if script_onDraw != "" {	
	catspeak_execute(global.scripts_level[? $"{script_onDraw}"]);	
}