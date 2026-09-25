event_inherited();
hitted=0;

on_sprite = spr_onoffswitch_red
off_sprite = spr_onoffswitch_blue

switch_state=false;

image_hit = sprite_index
image_exausted = sprite_index
image_speed=1;
depth=-1
flash=0

blockHit.Connect( self, function(hit_p, obj) {
	with(oGameManager) event_user(14)
	VinylPlay(snd_switch)
});