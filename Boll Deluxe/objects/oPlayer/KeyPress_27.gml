if (global.jade_testing) {
	room_goto(rEditor)
} else {
	room_goto(rMainMenu)
}

global.checkpointX = no_checkpoint;
global.checkpointY = no_checkpoint;

VinylStopAll();