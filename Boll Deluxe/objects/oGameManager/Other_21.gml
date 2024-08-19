///@description Switch Yellow Blocks
global.yellow_switch=!global.yellow_switch
instance_activate_object(oYellowSwitchBlock)
with(oYellowSwitchBlock) {
	switch_state=!switch_state
	event_user(0);
}
show_debug_message("Switched!")