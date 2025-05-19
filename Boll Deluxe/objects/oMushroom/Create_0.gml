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

collision_array=[oCollider, oEnemyGround];

depth=2

going=0;
parentblock=undefined;

node_init_vars()

itemType="mushroom"

itemCollected = new Signal();

itemCollected.Connect( self, function(hit_p, obj) {
	oPlayer.sig.Emit(itemType)
	instance_destroy();
});

setup_box_poly(id);