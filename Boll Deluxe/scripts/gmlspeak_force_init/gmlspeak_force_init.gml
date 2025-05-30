#macro GMLspeak global.__gmlspeak__

function gmlspeak_force_init() {
	static _init = false;
	if (_init) return;
	_init = true;
	
	GMLspeak = new GMLspeakEnvironment();
}
gmlspeak_force_init();