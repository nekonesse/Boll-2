event_inherited();
hitted=0;

image_hit = sprite_index
image_exausted = sprite_index
image_speed=1;
depth=-1
flash=0

blockHit.Connect( self, function(hit_p, obj) {
	with(oGameManager) event_user(11)
	VinylPlay(snd_switch)
	show_debug_message("Switch Pressed!")
});