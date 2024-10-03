event_inherited();
hitted=0;
content="coin"
bricked=false;
LDtkReloadFields()

if content=="multicoins" amount=12

times_hit = 0;
image_hit = spr_emptybox
image_exausted = spr_emptybox
image_speed=1;
depth=-1
flash=0
reduce_timer=0;

blockFinished.Connect( self, function() {
	event_user(1);
	image_speed=0;
	sprite_index = image_exausted;
	image_index = 0;
	no_hit=true;
	times_hit=0;
});

blockHit.Connect( self, function(hit_p, obj) {
	if !times_hit && content=="multicoins" reduce_timer=180;

	flash=bumpMax
	times_hit++;
	event_user(2);
});