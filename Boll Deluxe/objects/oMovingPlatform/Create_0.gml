// chearii: previous x and y positions for movement
event_inherited();

// set collision flag to floor only
semi = true

x_diff = 0;
y_diff = 0;
reverse = 0; //should the platform read regular dir or reverse dir
fallen = 0; //whether or not the platform has fallen
vsp = 0; //fallin vsp
grav = 0.15;

dir=0;;
spd=0.5;
image_speed=0;
depth=5;
fr=0