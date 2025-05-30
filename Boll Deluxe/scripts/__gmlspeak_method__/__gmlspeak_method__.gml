/// feather ignore all
/// @ignore
function __gmlspeak_method__(_scope, _func) {
	// Explicitly forcing methods
	if (is_method(_func)) { 
		return catspeak_method(_scope, _func);	
	} 
	
	show_error("Invalid function. Expected GMLspeakFunction/CatspeakFunction/Method.\nGot \"" + string(_func) + "\". With type \"" + typeof(_func) + "\".", true);
}