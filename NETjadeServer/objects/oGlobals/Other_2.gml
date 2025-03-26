global.roomTimer = 0;

window_set_size(480*3,270*3);
window_center();

//TODO: validate connection to master server here, then go to JADE
instance_create_depth(0,0,0,oNetManager)