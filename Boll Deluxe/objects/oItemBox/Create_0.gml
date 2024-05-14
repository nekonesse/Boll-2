event_inherited();
hitted=0;
content=Contents.Mushroom

image_exausted = spr_emptybox
image_speed=1;
depth=-1

blockFinished.Connect( self, function() {
    
	event_user(1);
	image_speed=0;
	sprite_index = image_exausted
	no_hit = true
});