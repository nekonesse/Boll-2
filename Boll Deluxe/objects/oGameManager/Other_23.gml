///@description Switch Magenta Blocks
global.magenta_switch=!global.magenta_switch
instance_activate_object(oMagentaSwitchBlock)
with(oMagentaSwitchBlock) {
	switch_state=!switch_state
	event_user(0);
}
show_debug_message("Switched!")