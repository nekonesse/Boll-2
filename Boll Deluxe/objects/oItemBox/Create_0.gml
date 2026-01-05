event_inherited();
hitted=0;
content="coin"
bricked=false;
hidden=false;
eject=false;
lose_amount=true;

times_hit = 0;
image_hit = spr_emptybox
image_exausted = spr_emptybox
image_speed=0;
flash=0
reduce_timer=0;

blockFinished.Connect( self, function() {
	image_speed=0;
	sprite_index = image_exausted;
	image_index = 0;
	no_hit=true;
	times_hit=0;
});

blockBumpFinished.Connect( self, function() {
	if (hit != 0) {
		event_user(1);
		if (eject != 0) {
			no_hit = true;
		}
	}
});

blockHit.Connect( self, function(hit_p, obj) {
	if !times_hit && content=="multicoins" reduce_timer=180;

	flash=bumpMax
	times_hit++;
	event_user(2);
	hidden = false;
	visible = 1;
	if (content != "multicoins") {
		no_hit = true;
	}
	if !(amount) {
		sprite_index = image_hit
	}
});