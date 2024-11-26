///CHANGE THESE IN VARIABLE DEFINITIONS
//hp, how many times the player can stomp/damage them, could be useful for things like rexes, or some weird crazy bosses.
//kidhp, how many kid bullets it takes to kill the enemy
//damage_on_contact, this already exists, will hurt the player if they collide with it at all, making it impossible to kill, unless you have a star. if its = 2 it would be invincible to stars aswell.
//no_stomping, this makes it so that the enemy doesnt lose hp/die when being stomped, so it would make it kinda act like an ant trooper from 3d world
//edgeturn, this basically just makes it turn on an edge like a red koopa/goombrat
//defaultgrav, gravity
//hsp, horizontal speed
//vsp, vertical speed
//polyfloor, hit the "floor" of a polygon
enemyStomped = new Signal();
enemyCollidePlayer = new Signal();
enemyFireballed = new Signal();
enemyKilled = new Signal();
grav=defaultgrav
rot=0
xsc=1
ysc=1
spawn_object=noone

inactive=0;
phaseid=noone;
turned=0;
turning=0;
in_shell=false;
collision_array=[oCollider, oEnemyGround];

killtype="";
killdir=0;

piped = false
grounded = false

hit_sizex = 6
hit_sizey = 6

image_xscale=1;
image_yscale=1;
depth=4;
sprindex_prev = sprite_index;

// boxpoly setup
setup_box_poly(id);

enemyStomped.Connect( self, function(hit_p) {
	if (!no_stomping) {
		hp-=1
		with(hit_p) {
			sig.Emit("enemy_stomped")
			instance_create_depth(x,y+hit_sizey,2,pImpact)
		}
		phaseid=hit_p
		killtype="stomp"
	}
});

enemyCollidePlayer.Connect( self, function(hit_p) {
	with(hit_p) sig.Emit("hurt_by_enemy")
	phaseid=hit_p
});

enemyFireballed.Connect( self, function(proj, hit_p) {
	hp-=1
	instance_create_depth(proj.x,proj.y,2,pImpact)
	killdir=esign(proj.x-x,1)
	killtype="spin"
});