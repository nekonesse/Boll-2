///@description JADE variable update
event_inherited()
if (bricked) {
	sprite_index=spr_brick
	image_normal=spr_brick
}

if !(amount) {
	image_speed=0;
	sprite_index = image_exausted;
	image_index = 0;
	no_hit=true;
	times_hit=0;
} else if content=="coin" amount=1
else if content=="multicoins" amount=12