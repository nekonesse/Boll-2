///@description Switch ON/OFF Blocks
global.onoff_state=!global.onoff_state
instance_activate_object(oONOFFBlock)
instance_activate_object(oONOFFSwitch)
instance_activate_object(oONOFFSingleSwitchRed);
with(oONOFFBlock) {
	switch_state=!switch_state
	event_user(0);
}
with(oONOFFSwitch) {
	switch_state=!switch_state
	event_user(0);
}
with(oONOFFSingleSwitchRed) {
	switch_state=!switch_state
	event_user(0);
}
show_debug_message("Switched!")