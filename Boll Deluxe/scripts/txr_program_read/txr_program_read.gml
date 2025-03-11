/// @param buffer
function txr_program_read(argument0) {
	var b/*:Buffer*/ = argument0;
	var n = buffer_read(b, buffer_u32);
	var w = array_create(n);
	var i=0;
	repeat (n) {
		w[i] = txr_action_read(b);
		i++;
	}
	return w;
}
