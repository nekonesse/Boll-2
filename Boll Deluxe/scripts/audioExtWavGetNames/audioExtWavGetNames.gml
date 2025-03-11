function audioExtWavGetNames() {
	if (__AUDIO_EXT_WEB) {
		__audioExtTrace("Web is not supported at this time.");
		return -1;
	}
	
	return variable_struct_get_names(global.__audioExtSystem.wavMap);
}