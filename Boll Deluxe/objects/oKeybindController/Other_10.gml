/// @description Do Keybinding Shit
input_binding_scan_abort();

input_binding_scan_start(function(_binding)
{
	input_binding_set_safe(rebinding_verb, _binding);
});