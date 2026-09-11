if (global.jade_testing) {
	room_goto(rEditor)
} else {
	if (demo_build)
         room_goto(rTECHDEMO_Disclaimer);
    else room_goto(rMainMenu);
}

global.checkpointX = no_checkpoint;
global.checkpointY = no_checkpoint;

VinylStopAll();