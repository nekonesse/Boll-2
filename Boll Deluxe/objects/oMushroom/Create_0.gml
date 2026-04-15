hsp=0
vsp=0
defaultgrav=0.25
grav=defaultgrav
rot=0
xsc=1
ysc=1
grounded = false
piped = false

hit_sizex = 6
hit_sizey = 6
phase_leeway = 0;
phaseid = noone;
colangle = 0;

fric = 0;

collision_array=[oCollider, oEnemyGround];

depth=2

going=0;
parentblock=undefined;

node_init_vars()

itemType="mushroom"

itemCollected = new Signal();
escapeItemBox = new Signal();

itemCollected.Connect( self, function(hit_p) {
	hit_p.sig.Emit(itemType)
	
	instance_create_depth(x,y,depth,pGlowRing);
	
	var dir = 30;
	repeat(3) {
		make_particle(pGlitter,x,y,depth-1,1,lengthdir_x(2,dir),lengthdir_y(2,dir),0,0);
		dir+=120;
	}
	
	instance_destroy();
});

escapeItemBox.Connect( self, function() {
	hsp = 0.75*((nearestplayer().x > x) ? -1 : 1);
});