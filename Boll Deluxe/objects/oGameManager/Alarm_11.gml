/// @description go to menu
if !(global.jade_testing) {
	room_goto(rMainMenu);
} else {
	global.jade_testing=false;
	room_goto(rEditor);
}
