onConducted=new Signal();

onConducted.Connect( self, function(conductor) {
	conducted = true
});

conducted = false;

reverse = 0; //should the platform read regular dir or reverse dir
fallen = 0; //whether or not the platform has fallen
vsp = 0; //fallin vsp
grav = 0.15;
radius = 64;

node_init_vars()

dir=0;
spd=0;
depth=5;