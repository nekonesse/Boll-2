///@description Switch Cyan Blocks
global.cyan_switch=!global.cyan_switch
instance_activate_object(oCyanSwitchBlock)
with(oCyanSwitchBlock) {
	switch_state=!switch_state
	event_user(0);
}
show_debug_message("Switched!")