xsc = -1
ysc = 0
state = 0
xdist = 0
ydist = 0

target = noone;
stalled = false;

// camera zoom
can_zoom = false; // can the camera zoom yet?
zoom_delay = 16;   // delay in frames before the can_zoom check, prevents instant zoomout on level start

// set up in a way to have NSMB-style level starts
zoom = 0.5;       // zoom value
target_zoom = 1;  // target zoom value

xsensor = CAM_SENSOR_WIDTH;
ysensor = CAM_SENSOR_HEIGHT;

// camera nudges
// handled as an array: [nudge, destination]
xnudge = [0, 0];
ynudge = [0, 0];
ynudgespd = 0;

// finalized position after all the CRAP
x_final = 0;
y_final = 0;

x_final_prev = x_final;
y_final_prev = y_final;

xbounds = camera_get_view_width(view_camera[0]);
ybounds = camera_get_view_height(view_camera[0]);