global.jade_testing = false;

global.checkpointX = no_checkpoint;
global.checkpointY = no_checkpoint;

VinylStopAll();

if (demo_build)
    room_goto(rTECHDEMO_Disclaimer);
else room_goto(rMainMenu);